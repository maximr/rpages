module RpagesSelectable
  extend ActiveSupport::Concern

  included do
    #config variables
    self.name_field = :name
  end

  module ClassMethods
    attr_accessor :name_field
    
    def get_selectable_collection
      @id_selection ||= self.pluck(self.name_field, :id).each_with_object(Array.new(0)) {|e, a| a << {:id => e[1], :text => e[0]}}
    end

    def get_preselected_collection(selection)
      selection.pluck(self.name_field, :id).each_with_object(Hash.new(0)) {|e, a| a[e[0]] = e[1]}
    end
  end

  def generate_html_parsable_hash(title, content, klass, tag)
    { 
      title: title,
      content: content,
      class: klass,
      tag: tag
    }
  end
end