# == Schema Information
#
# Table name: setts
#
#  id              :integer          not null, primary key
#  sett_object     :string           default("none")
#  sett_type       :string           default("none")
#  created_by      :integer          default("0")
#  updated_by      :integer          default("0")
#  primary         :boolean          default("false")
#  sett_objects_id :integer
#  name            :string
#

class Sett < ApplicationRecord
  include CollectionModel

  has_many     :sett_objects, dependent: :destroy
  has_many     :page_setts, dependent: :destroy
  has_many     :pages, through: :page_setts

  accepts_nested_attributes_for :sett_objects, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :pages, reject_if: :all_blank

  before_save :update_primaries

  scope :primary, -> { self.where(:primary => true) }
  scope :main, -> { self.where(:sett_object => 'main_settings') }
  scope :default, -> { self.where(:sett_type => 'default') }
  scope :meta, -> { self.where(:sett_type => 'meta') }
  scope :nav, -> { self.where(:sett_object => 'navigation') }
  scope :footer, -> { self.where(:sett_object => 'footer') }
  scope :tracking, -> { self.where(:sett_object => 'tracking') }
  scope :menu, -> { self.where(:sett_type => 'menu') }
  scope :collection, -> { self.where(:sett_type => 'collection') }

  validates :name, presence: true, uniqueness: true, length: { maximum: 400 }

  SETT_OBJECTS = ["none", "main_settings", "navigation", "contact_links", "footer", "tracking", "style"]
  SETT_TYPES = ["none", "meta", "default", "menu", "collection"]

  #class helpers

  def self.has_main?
    self.main.present?
  end

  def self.has_default?
    self.default_main.present?
  end

  def self.has_meta?
    self.meta_main.present?
  end

  def self.get_default_collection
    #{'none': 0}.merge(self.pluck(:name,:id).each_with_object(Hash.new(0)) { |e, a| a[e[0].to_s] = e[1] })
    self.pluck(:name,:id).each_with_object(Hash.new(0)) { |e, a| a[e[0].to_s] = e[1] }
  end

  def self.get_x?(selector, only_primary=true)
    only_primary ? self.primary.where(sett_object: selector) : self.where(sett_object: selector)
  end

  def self.has_x?(selector, only_primary=true)
    self.get_x?(selector, only_primary).present?
  end

  #helpers

  def get_objects
    @obj ||= self.sett_objects.order(priority: :asc)
  end

  def get_x(object, clean_output = true)
    selector = has_x?(object) ? get_objects.where(title: object).first.body : ''
    clean_output ? ActionView::Base.full_sanitizer.sanitize(selector).gsub(/[\r\n]/, '') : selector.gsub(/[\r\n]/, '')
  end

  def has_x?(object)
    get_objects.where(title: object).present?
  end

  def get_images
    @img ||= get_objects.where.not(image_file_name: nil)
  end

  def get_icons
    @icon ||= get_objects.where.not(icon_file_name: nil)
  end

  def has_image?
    get_images.present?
  end

  def has_icon?
    get_icons.present?
  end

  def get_user_name(id)
    User.find(id).present? ? User.find(id).name : 'unknown'
  end

  private

  def update_primaries
    if self.primary
      Sett.where(primary: true, sett_object: self.sett_object, sett_type: self.sett_type).where.not(id: self.id).each {|e| e.update(primary: false)}
    end
  end
end
