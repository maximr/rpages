# == Schema Information
#
# Table name: galleries
#
#  id           :integer          not null, primary key
#  title        :string
#  gallery_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pics_id      :integer
#

class Gallery < ApplicationRecord
  include RpagesSelectable

  has_and_belongs_to_many :content_blocks, join_table: "cb_galleries"
  has_many                :pics

  accepts_nested_attributes_for :content_blocks, reject_if: :all_blank
  accepts_nested_attributes_for :pics, reject_if: :all_blank, allow_destroy: true

  def self.get_default_collection
    {'none': 0}.merge(self.pluck(:title,:id).each_with_object(Hash.new(0)) { |e, a| a[e[0].to_s] = e[1] })
  end

  def num_of_pics
    self.pics.present? ? self.pics.count : 0
  end
end
