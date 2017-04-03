# == Schema Information
#
# Table name: pics
#
#  id                 :integer          not null, primary key
#  title              :string
#  picture_type       :string
#  position           :integer          default(0)
#  gallery_id         :integer
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Pic < ApplicationRecord
  belongs_to :gallery

  accepts_nested_attributes_for :gallery, reject_if: :all_blank

  has_attached_file :image, 
                      styles: { 
                        thumb: "75x75#",
                        mobile_xs: "480x800>",
                        mobile_sm: "720x1024>",
                        mobile_md: "640x960>",
                        mobile_ll: "640x1136",
                        mobile_xl: "1080x1920>",
                        tablet_xs: "1280x800>",
                        tablet_xl: "1536x2048>",
                        xs: "544x340>", 
                        sm: "767x479>", 
                        md: "991x619>", 
                        ll: "1300x819>", 
                        hd: "1920x1080>", 
                        xl: "2880x1800" 
                      }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  process_in_background :image

  def get_content
    title.present? ? title : nil
  end
end
