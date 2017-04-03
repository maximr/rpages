module ActiveAdminHelper
  def get_colums(objekkt)
    objekkt.get_index_params.each do |field|
      if objekkt.is_special_field?(field)
        render_image_field(field, objekkt) if objekkt.is_image_field?(field)
      else
        column field
      end
    end
  end

  def render_image_field(field, objekkt) #to avoid naming conflicts
    column field do |objekkt|
      if objekkt.send(field).exists?
        image_tag(objekkt.send(field).url(:thumb))
      else
        span do
          "- no image -"
        end
      end
    end
  end

  def get_form_fields(objekkt, form)
    objekkt.get_form_params.each do |field|
      if objekkt.is_special_field?(field)
        if objekkt.is_image_field?(field)
          form.input field, as: :file, :image_preview => true
          form.input "remove_#{field}"
        end
        form.input field, objekkt.get_ck_params(field) if objekkt.is_ck_field?(field)
        form.input field, :input_html => { :value => form.object.send(field) }, as: :hidden if objekkt.is_system_field?(field)
      else
        form.input field unless objekkt.is_remove_param?(field)
      end
    end
  end

  def get_filters(objekkt)
    objekkt.filters.each do |fil|
      filter fil
    end
  end
end