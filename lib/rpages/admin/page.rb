if defined?(ActiveAdmin)
  ActiveAdmin.register Page do
    menu parent: "Rpages", priority: 80

    controller do
      defaults :finder => :find_by_slug
      before_action :block_delete_for_primary, :only => [:destroy]
      before_action :inform_about_delay, :except => [:destroy, :show, :index, :edit]

      def inform_about_delay
        flash[:notification] = "Please allow some time for the images and videos to process in the background..."
      end 

      def block_delete_for_primary
        if Page.find_by_slug(params[:id]).primary_page
          flash[:alert] = "You can't delete primary pages - remove the primary flag first..."
          redirect_to action: :show
        end
      end 
    end

    #permit_params Page.get_permit_params

    permit_params :id, :primary, :name, :headline, :sub_headline, :slug, :body, :author_id, :associaton_model, :primary_page, :active, sett_ids: [], associaton_ids: [],
                  content_blocks_attributes: [ :key, :content, :the_type, :associaton_model, :priority, :id, :_destroy, 
                                               :css_class, :css_id, :content_image, :remove_content_image, :background_image, :remove_background_image, :block_spacing, :block_color, :content_position, 
                                               :block_text_color, :block_text_color_active, :block_animation, :block_animation_delay, :block_animation_active, :block_width_breakpoints,
                                               :block_title, :background_color_active, :block_template, :template_animation_in, :template_animation_out,
                                               :template_timing, :template_limiter, :video, :video_preview, :remove_image, :remove_video, :remove_video_preview, :link_type, :remove_gallery, 
                                               block_appearance: [],
                                               associaton_ids: [],
                                               gallery_ids: [],
                                               galleries_attributes: [:id, :title, :gallery_type, :_destroy], 
                                             ]

    index do
      column :name
      column :headline
      column :primary_page
      column :active

      actions
    end

    filter :name
    filter :headline
    filter :primary_page
    filter :active
    

    form do |f|
      f.semantic_errors

      f.inputs "Page Details" do
        f.input :name
        f.input :headline
        f.input :sub_headline
      end

      f.inputs "Page Settings" do
        f.input :active, as: :boolean, hint: "Display page link on website"
        f.input :primary_page, as: :boolean, hint: "!!!!!!!! WILL SET THIS PAGE AS THE START PAGE FOR THIS SITE - will remove other primary pages !!!!!!"
      end

      f.inputs "Page Associations" do
        f.input :associaton_model, as: :select, collection: Page.get_association_models, include_blank: false, hint: 'The Model associatited with this page', wrapper_html: {class: 'select2_enabler'}
        f.input :associaton_ids, as: :select, wrapper_html: {class: 'select2_ajax select_extend'}, input_html: { disabled: true }, collection: f.object.get_selection_hash, include_hidden: false, multiple: true
      end

      # f.inputs "Default Content" do
      #   f.input :description, as: :ckeditor, input_html: { class: 'ck_field', ckeditor: { height: 100, allowedContent: "h2 h3 h4 h5 strong em Underline JustifyCenter" }}, label: false
      #   f.input :body, as: :ckeditor, input_html: { class: 'ck_field', ckeditor: { height: 400 }}, label: false
      # end

      f.inputs "Content", class: "content_block_wrapper" do
        div class: "content_block_container default_block_container" do
          f.has_many :content_blocks, heading: false, allow_destroy: true, new_record: "Add block", sortable: :priority, class: "slim_content_block" do |rcb|
            rcb.input :block_spacing, as: :select, collection: ContentBlock::SPACINGS, include_blank: false, wrapper_html: { data: {group: "settings"} }
            rcb.input :link_type, as: :select, collection: ContentBlock::LINK_TYPES, include_blank: false, wrapper_html: { data: {group: "settings"} }, hint: "Type of link for the actions"
            #rcb.input :block_appearance, as: :select, collection: ContentBlock::BLOCK_APPEARANCES, include_blank: false, wrapper_html: { data: {group: "settings"} }
            rcb.input :content_position, as: :select, collection: ContentBlock::CONTENT_POSITIONS, include_blank: false, wrapper_html: { data: {group: "settings"} }
            rcb.input :block_width_breakpoints, wrapper_html: { data: {group: "settings"} }, hint: "Width for each breakpoint 1-12 (has to be 6 numbers)"

           
            rcb.input :block_appearance, include_hidden: false, as: :select2_multiple, collection: ContentBlock::BLOCK_APPEARANCES, wrapper_html: { data: {group: "settings"}, class: "select_extend" }
            

            rcb.input :the_type, hint: "available types: pageconent", as: :select, collection: ContentBlock.get_collection(ContentBlock::BLOCK_TYPES), include_blank: false, wrapper_html: { data: {group: "advanced"} }
            rcb.input :associaton_model, as: :select, collection: ContentBlock.get_association_models, include_blank: false, hint: 'The Model associatited with this block', wrapper_html: { data: {group: "advanced"}, class: 'select2_enabler' }
            rcb.input :associaton_ids, as: :select, wrapper_html: {class: 'select2_ajax select_extend', data: {group: 'advanced'}}, input_html: { disabled: true }, collection: rcb.object.get_selection_hash, multiple: true, include_hidden: false

            #rcb.input :association_content, hint: "selection of the content you want to display. ex. StreamTitle#Other Stream Title (can be filtered [id|4-13], [priority|1/2/5]) - leave it empty (-:", wrapper_html: { data: {group: "advanced"} }
            #rcb.input :association_type, hint: "example: Stream - leave this empty for anything but stream containers", wrapper_html: { data: {group: "advanced"} }
            rcb.input :background_image, :as => :file, hint: "background image for this slide", :image_preview => true, wrapper_html: { data: {group: "advanced", preview: true} }
            rcb.input :remove_background_image, wrapper_html: { data: {group: "advanced"} }
            rcb.input :video, :as => :file, hint: "Video for this slide - has the highest prio", wrapper_html: { data: {group: "advanced"} }
            rcb.input :remove_video, wrapper_html: { data: {group: "advanced"} }
            rcb.input :video_preview, :as => :file, hint: "Preview image for the video", :image_preview => true, wrapper_html: { data: {group: "advanced", preview: true} }
            rcb.input :remove_video_preview, wrapper_html: { data: {group: "advanced"} }
            rcb.input :galleries, as: :select2_multiple, wrapper_html: {data: {group: "advanced"}, class: "select_extend select_extend--alt"}, collection: Gallery.get_default_collection, include_hidden: false
            rcb.input :remove_gallery, wrapper_html: { data: {group: "advanced"}, class: "remove--alt" }
            rcb.input :content_image, :as => :file, hint: "the content image", :image_preview => true, wrapper_html: { data: {group: "advanced", preview: true} }
            rcb.input :remove_content_image, wrapper_html: { data: {group: "advanced"} }

            rcb.input :block_color, wrapper_html: { data: {group: "style"} }
            rcb.input :background_color_active, wrapper_html: { data: {group: "style"} }
            rcb.input :block_text_color, wrapper_html: { data: {group: "style"} }
            rcb.input :block_text_color_active, wrapper_html: { data: {group: "style"} }
            rcb.input :block_animation, as: :select, collection: ContentBlock.get_collection(ContentBlock::ANIMATIONS), include_blank: false, wrapper_html: { data: {group: "style"} }
            rcb.input :block_animation_delay, wrapper_html: { data: {group: "style"} }
            rcb.input :block_animation_active, wrapper_html: { data: {group: "style"} }
            rcb.input :css_class, hint: "available classes: slide--black_back, slide--main_back [fade-1, fade-2, ...] (non -> white), image-right, image-left, image-none", wrapper_html: { data: {group: "style"} }
            rcb.input :css_id, hint: "inline css styles", wrapper_html: { data: {group: "style"} }, as: :text

            rcb.input :block_template, as: :select, collection: ContentBlock.get_collection(ContentBlock::BLOCK_TEMPLATES), include_blank: false, wrapper_html: { data: {group: "template", type: "title_sub"} }
            rcb.input :template_animation_in, as: :select, collection: ContentBlock.get_collection(ContentBlock::ANIMATIONS), include_blank: false, wrapper_html: { data: {group: "template"} }
            rcb.input :template_animation_out, as: :select, collection: ContentBlock.get_collection(ContentBlock::ANIMATIONS), include_blank: false, wrapper_html: { data: {group: "template"} }
            rcb.input :template_timing, wrapper_html: { data: {group: "template"} }, hint: "Delay for automatic switch in ms 1s = 1000,..."
            rcb.input :template_limiter, wrapper_html: { data: {group: "template"} }, hint: "Num. of items per resolution breakpoint (6 num, seperated by comma)"

            rcb.input :block_title, wrapper_html: { data: {type: "title"} }
            rcb.input :key, placeholder: "new block"

            rcb.input :content, as: :ckeditor, input_html: { class: 'ck_field', ckeditor: { height: 500 }}, label: false
          end
        end
      end

      f.inputs "Setts", class: "select2_block_wrapper" do
        f.input :setts, include_hidden: false, as: :select2_multiple, collection: Sett.get_default_collection, wrapper_html: { class: "select_extend" }, label: false
      end

      f.input :author_id, :input_html => { :value => current_user.id }, as: :hidden

      f.actions
    end

    sidebar "Page Details", only: :show do
      panel "Overview" do
        attributes_table_for page do
          row "URL" do
            link_to "/#{page.slug}", "/#{page.slug}", target: 'blank'
          end

          row :name
          row :id
          row :active
          row :primary_page
          row :page_type
        end
      end

      panel "Setts" do
        div class: "content_block_display_container content_block_display_container--sidebar" do
          if resource.setts.present?
            resource.setts.each do |block|
              div class: "content_block" do
                h3 do
                  span "[#{block.sett_type}] #{block.name}"

                  i class: "fa fa-sitemap fa-lg" 
                end
              end
            end
          else
            h2 "This page has no setts yet..."
          end
        end
      end
    end

    show title: :name do
      attributes_table do
        row :headline
        row :sub_headline
      end

      # panel "Default Description" do
      #   raw resource.description
      # end

      panel "Default Content" do
        raw resource.body
      end

      panel "Content Blocks" do
        div class: "content_block_display_container" do
          if resource.content_blocks.present?
            resource.content_blocks.each do |block|
              div class: "content_block" do
                h3 do
                  span block.get_block_title

                  i class: "fa fa-list fa-lg" 
                end

                panel "Content Preview", class: "preview-container" do
                  if block.video.exists?
                    video_tag(block.video.url(:mp4), controls: true)
                  elsif block.background_image.exists?
                    image_tag(block.background_image.url(:xs))
                  else
                    span do
                      "- no media content -"
                    end
                  end
                end
              end
            end
          else
            h2 "This page has no content yet..."
          end
        end
      end

    end
  end
end
