module ActiveAdminModel
  extend ActiveSupport::Concern

  included do
    include RemoveableAttachments

    #config variables
    self.system_fields = ['id', 'created_at', 'updated_at']
    self.blocked_params = []
    self.remove_from_form = ['id', 'created_at', 'updated_at']
    self.index_fields = []
    self.ck_fields = []
    self.full_ck_fields = []
    self.attachment_fields = []
    self.image_fields = []
    self.filters = []
  end

  module ClassMethods
    attr_accessor :system_fields, :blocked_params, :remove_from_form, :index_fields, :ck_fields, :full_ck_fields, :attachment_fields, :image_fields, :filters

    def get_permit_params
      get_params('blocked_params')
    end
    
    def get_form_params
      append_attachments get_params('remove_from_form'), self.system_fields
    end

    def get_index_params
      self.index_fields
    end

    def get_params(filter)
      if ActiveRecord::Base.connection.data_source_exists? self.name.pluralize.downcase
        out = self.column_names.delete_if {|i| self.send(filter).include?(i) || is_paperclip_field?(i) }
        append_attachments(out, paperclip_attachments)
      end
    end

    def is_paperclip_field?(field)
      paperclip_attachments.each do |att|
        search_string = "#{att}_"
        return true if field.include?(search_string)
      end

      false
    end

    def paperclip_attachments
      @paperclip_attachments ||= self.new.get_paperclip_attachments
    end

    def append_attachments(array, attachments)
      attachments.each {|a| array << a }
      array.uniq
    end

    def is_remove_param?(field)
      field.to_s.include?('remove_')
    end

    def is_special_field?(field)
      is_ck_field?(field) || is_image_field?(field) || is_image_field?(field) || is_system_field?(field)
    end

    def is_ck_field?(field)
      self.full_ck_fields.to_a.include?(field) || self.ck_fields.to_a.include?(field)
    end

    def is_system_field?(field)
      self.system_fields.to_a.include?(field)
    end

    def get_ck_params(field)
      if self.full_ck_fields.include?(field)
        { as: :ckeditor, input_html: { class: 'ck_field', ckeditor: { height: 400 }}, label: false }
      else
        { as: :ckeditor, input_html: { class: 'ck_field', ckeditor: { height: 400, allowedContent: "h2 h3 h4 h5 strong em Underline JustifyCenter" }}, label: false }
      end
    end

    def is_image_field?(field)
      self.image_fields.to_a.include?(field)
    end

    def is_attachment_field?(field)
      self.attachment_fields.to_a.include?(field)
    end
  end
end
