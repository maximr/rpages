# == Schema Information
#
# Table name: pages
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  headline          :string           not null
#  sub_headline      :string
#  slug              :string
#  description       :text
#  body              :text
#  author_id         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  primary_page      :boolean          default("false")
#  active            :boolean          default("false")
#  page_type         :string           default("none")
#  content_blocks_id :integer
#  remove_image      :boolean          default("false")
#  meta_description  :text
#

class Page < ApplicationRecord
  include RemoveableAttachments
  include ActiveAdminModel #fix me
  include SluggishModel
  include PrimaryPageModel
  include AssociationModel

  has_many     :content_blocks, dependent: :destroy
  has_many     :page_setts
  has_many     :setts, through: :page_setts

  accepts_nested_attributes_for :content_blocks, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :setts, reject_if: :all_blank, allow_destroy: true

  after_save :reload_routes

  self.slug_field = :name
  self.ck_fields = ['description']
  self.full_ck_fields = ['body']
  self.filters = ['name', 'headline', 'author_id']
  self.index_fields = ['image', 'name']
  self.image_fields = ['image']

  PAGE_TYPES = ["none", "main", "footer"]

  scope :active, -> { self.where(:active => true) }
  scope :main_pages, -> { self.where(:page_type => PAGE_TYPES[1]) }
  scope :footer_pages, -> { self.where(:page_type => PAGE_TYPES[2]) }

  validates :name, uniqueness: true, presence: true
  validates :headline, presence: true

  #class methods
  def self.get_collection
    PAGE_TYPES.each_with_object(Hash.new(0)) { |e, a| a[e.upcase] = e }
  end

  #intance methods

  def is_footer_page?
    page_type == PAGE_TYPES[2]
  end

  def get_slide_containers
    content_blocks.get_all("pagecontent")
  end

  #setts

  def get_sett_x(sett_object, sett_type = nil)
    lambda {|selection| selection.present? ? selection.first : Sett.where(sett_object: sett_object, sett_type: sett_type, primary: true).first }.call(sett_type.nil? ? self.setts.where(sett_object: sett_object) : self.setts.where(sett_object: sett_object, sett_type: sett_type))
  end

  private

  def reload_routes
    DynamicRouter.reload
  end

end