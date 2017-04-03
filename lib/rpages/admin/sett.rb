if defined?(ActiveAdmin)
  ActiveAdmin.register Sett do
    menu parent: "Rpages", priority: 81

    controller do
      before_action :block_delete_for_primary, :only => [:destroy]
      before_action :inform_about_delay, :except => [:destroy, :show, :index, :edit]

      def inform_about_delay
        flash[:notification] = "Please allow some time for the images and videos to process in the background..."
      end 

      def block_delete_for_primary
        if Sett.find(params[:id]).primary
          flash[:alert] = "You can't delete primary setts - remove the primary flag first..."
          redirect_to action: :show
        end
      end 
    end

    permit_params :id, :sett_object, :sett_type, :created_by, :updated_by, :primary, :sett_objects_id, :name,
                  sett_objects_attributes: [ 
                    :id, :_destroy, :priority, :title, :object_type, :object_value, :object_modifier, :body,
                    :image, :remove_image, :icon, :remove_icon, :sett_id
                  ]

    index do
      column :sett_object
      column :sett_type
      column :name
      column :created_by do |sett|
        sett.get_user_name(sett.created_by)
      end
      column :primary

      actions
    end

    filter :name
    filter :sett_object
    filter :sett_type
    filter :created_by
    filter :primary

    form do |f|
      f.semantic_errors

      f.inputs "Sett Config" do
        f.input :name, hint: 'the name of this Sett - internal use only (identifier)'
        f.input :sett_object, as: :select, collection: Sett.get_collection(Sett::SETT_OBJECTS), include_blank: false
        f.input :sett_type, collection: Sett.get_collection(Sett::SETT_TYPES), include_blank: false
        f.input :primary, as: :boolean, hint: "!!!!!!!! WILL SET THIS AS PRIMARY SETT FOR THIS TYPE - will remove other primary setts !!!!!!"
      end

      f.inputs "Sett Objects", class: "content_block_wrapper" do
        div class: "content_block_container default_block_container" do
          f.has_many :sett_objects, heading: false, allow_destroy: true, new_record: "Add object", sortable: :priority, class: "slim_content_block light_content_block" do |rcb|
            rcb.input :object_type, wrapper_html: { data: {group: "settings", type: "title_sub"} }, collection: SettObject.get_collection(SettObject::SETT_OBJECT_TYPES), include_blank: false
            rcb.input :object_value, wrapper_html: { data: {group: "settings"} }, as: :select, collection: Sett.get_default_collection, include_blank: false
            rcb.input :object_modifier, wrapper_html: { data: {group: "settings"} }

            rcb.input :image, :as => :file, hint: "the image", :image_preview => true, wrapper_html: { data: {group: "advanced", preview: true} }
            rcb.input :remove_image, wrapper_html: { data: {group: "advanced"} }
            rcb.input :icon, :as => :file, hint: "the icon", :image_preview => true, wrapper_html: { data: {group: "advanced", preview: true} }
            rcb.input :remove_icon, wrapper_html: { data: {group: "advanced"} }

            rcb.input :title, wrapper_html: { data: {type: "title"} }
            rcb.input :body, as: :ckeditor, input_html: { class: 'ck_field', ckeditor: { height: 300 }}, label: false
          end
        end
      end

      f.input :created_by, :input_html => { :value => f.object.created_by == 0 ? current_user.id : f.object.created_by }, as: :hidden
      f.input :updated_by, :input_html => { :value => current_user.id }, as: :hidden

      f.actions
    end

    sidebar "Sett Details", only: :show do
      panel "Overview" do
        attributes_table_for sett do
          row :id
          row :primary
        end
      end

      panel "Modifications" do
        attributes_table_for sett do
          row :created_by do |sett|
            sett.get_user_name(sett.created_by)
          end
          row :updated_by do |sett|
            sett.get_user_name(sett.updated_by)
          end
        end
      end
    end

    show title: :name do
      attributes_table do
        row :sett_object
        row :sett_type
      end

      panel "Sett Objects" do
        div class: "content_block_display_container" do
          if resource.sett_objects.present?
            resource.sett_objects.each do |block|
              div class: "content_block" do
                h3 do
                  span "[#{block.object_type}] #{block.title}"

                  i class: "fa fa-sitemap fa-lg" 
                end
                panel "Content Preview", class: "preview-container" do
                  if block.image.exists?
                    image_tag(block.image.url(:thumb))
                  elsif block.icon.exists?
                    image_tag(block.icon.url(:thumb))
                  else
                    span do
                      "- no media content -"
                    end
                  end
                end
              end
            end
          else
            h2 "This sett has no sett objects yet..."
          end
        end
      end

    end
  end
end