# == Schema Information
#
# Table name: sett_objects
#
#  id                 :integer          not null, primary key
#  priority           :integer          default("0")
#  title              :string
#  object_type        :string           default("none")
#  object_value       :string           default("none")
#  object_modifier    :string           default("none")
#  body               :text
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  remove_image       :boolean          default("false")
#  icon_file_name     :string
#  icon_content_type  :string
#  icon_file_size     :integer
#  icon_updated_at    :datetime
#  remove_icon        :boolean          default("false")
#  sett_id            :integer
#

class SettObject < ApplicationRecord
  include RemoveableAttachments
  include CollectionModel

  default_scope { order('priority ASC') }

  belongs_to :sett, touch: true
  accepts_nested_attributes_for :sett, reject_if: :all_blank

  has_attached_file :image, styles: { thumb: "75x75#", x01: "50>", x03: "150>", x05: "250>", x075: "375>", x500: "500>", fb: "1200x630#", og: "1200x1200#" }, 
                            source_file_options:  { all: '-background transparent' }
  has_attached_file :icon, styles: { 
                            thumb: "75x75#", x16: "16x16#", x32: "32x32#", x57: "57x57#", x70: "70x70#", 
                            x96: "96x96#", x114: "114x114#", x120: "120x120#", x128: "128x128#", x144: "144x144#",
                            x150: "150x150#", x152: "152x152#", x196: "196x196#", x310: "310x310#", ico: ["64x64#",:ico]
                          }, source_file_options:  { all: '-background transparent' }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\z/

  process_in_background :image
  process_in_background :icon

  SETT_OBJECT_TYPES = ["none", "social_link", "tracker", "link", "row", "collection", "font", "font-style"]

  #helpers

  def type_is?(selector)
    self.object_type == selector
  end

  def value_is?(selector)
    self.object_value == selector
  end

  def modifier_is?(selector)
    self.object_modifier == selector
  end

  def clean_output(selector)
    ActionView::Base.full_sanitizer.sanitize(self.send(selector)).gsub(/[\r\n]/, '').to_s.chars.select {|c| c.ord < 128 }.join
  end

  def get_polymorphic_object(id)
    Sett.where(id: id.to_i).first
  end
end
