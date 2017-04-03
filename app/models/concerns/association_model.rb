module AssociationModel
  extend ActiveSupport::Concern

  included do
    before_save         :update_associations

    #config variables
    self.excluded_classes = ['Page', 'Sett', 'User', 'Gallery', 'Pic', 'ContentBlock', 'PageSett', 'SettObject']

    # self.blocked_params << 'slug'

    # scope :primary, -> { self.where(:primary_page => true) }
  end

  module ClassMethods
    attr_accessor :excluded_classes

    def get_association_models
      ApplicationRecord.descendants.map(&:name).delete_if {|p| self.excluded_classes.include?(p)}.unshift('none').each_with_object(Hash.new(0)) { |e, a| a[e.upcase] = e }
    end
  end

  def get_association(reoder_items=true)
    if has_association_object? && get_association_object
      out = get_association_selection ? get_association_selection : false

      reoder_items && out && !out.nil? && out.first.respond_to?(:priority) ? out.reorder(priority: :asc) : out
    else
      false
    end
  end

  def get_selection_hash
    if has_association_object? && get_association_object
      @association_object.get_preselected_collection get_association
    else
      {}
    end
  end

  def get_association_object
    @association_object ||= get_main_association
  end

  def get_association_selection
    @association_selection ||= @association_object.where(id: self.associaton_ids)
  end

  def has_association_object?
    self.associaton_model.nil? || self.associaton_model.to_s.downcase == 'none' ? false : true
  end

  def get_main_association
    if is_sub_association?
      get_sub_assocations

      if sub_assocations_include?
        self.page.get_association.first.send(self.associaton_model.to_s.downcase.pluralize)
      else
        self.associaton_model.constantize
      end
    else
      self.associaton_model.constantize
    end
  end

  def is_sub_association?
    self.respond_to?(:page) && self.page.has_association_object?
  end

  def get_sub_assocations
    @sub_associations ||= self.page.associaton_model.constantize.reflect_on_all_associations.map(&:klass).map(&:name)
  end

  def sub_assocations_include?
    @sub_associations.include?(self.associaton_model.constantize.name)
  end

  private

  def update_associations

  end
end