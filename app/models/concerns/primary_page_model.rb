module PrimaryPageModel
  extend ActiveSupport::Concern

  included do
    before_save         :update_primaries
    #after_save          :update_routes

    scope :primary, -> { self.where(:primary_page => true) }
  end

  module ClassMethods
    def has_primary?
      self.primary.present?
    end

    def get_primary
      primary = '/not_found'
      primary = Rails.application.routes.url_helpers.send("#{Page.primary.first.slug.gsub('-','_')}_path") if Page.has_primary?
      primary
    end
  end

  def is_primary?
    self.primary_page
  end

  private

  def update_routes
    DynamicRouter.reload
  end

  def update_primaries
    if self.primary_page
      Page.where(primary_page: true).where.not(id: self.id).each {|e| e.update(primary_page: false)}
    end
  end
end
