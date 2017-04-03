module SluggishModel
  extend ActiveSupport::Concern

  included do
    before_validation :update_slug
    after_save        :update_routes

    validates :slug, presence: true, uniqueness: true, length: { maximum: 400 }

    #config variables
    self.slug_field = :name

    self.blocked_params << 'slug'
    self.remove_from_form << 'slug'
  end

  module ClassMethods
    attr_accessor :slug_field

    def find_by_slug(param)
      where(slug: param).first
    end
  end

  def to_param
    slug
  end

  private

  def update_routes
    Rails.application.reload_routes!
  end

  def update_slug
    self.update_attribute(self.class.slug_field, self.send(self.class.slug_field).to_s.downcase)
    self.slug = self.send(self.class.slug_field).downcase.to_url
  end
end