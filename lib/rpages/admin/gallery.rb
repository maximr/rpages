if defined?(ActiveAdmin)
  ActiveAdmin.register Gallery do
    menu parent: "Rpages", priority: 82

    controller do
      before_action :inform_about_delay, :except => [:destroy, :show, :index, :edit]

      def inform_about_delay
        flash[:notification] = "Please allow some time for the images and videos to process in the background..."
      end
    end

    permit_params picture_ids: [], office_ids: [], service_ids: []

    permit_params :title, :gallery_type, 
                  pictures_attributes: [:id, :title, :image, :position, :_destroy],
                  offices_attributes: [:id],
                  services_attributes: [:id]

    index do
      column :title
      column :num_of_pics
      column :created_at
      actions
    end

    filter :title
    filter :num_of_pics
    filter :created_at
    filter :updated_at

    form :html => { :multipart => true } do |f|
      f.inputs "Galerie Details" do
        f.input :title
        f.input :gallery_type
        f.inputs "Content Blocks", class: "select2_block_wrapper" do
          f.input :content_blocks, include_hidden: false, as: :select2, collection: ContentBlock.get_default_collection, wrapper_html: { class: "select_extend" }, label: false
        end
      end

      f.inputs "Pictures" do
        if f.object.id.present?
          gallery_id = f.object.id.nil? ? 1 : f.object.id
          render "active_admin_multi_upload/upload_form", resource: f.object, association: "pics", attribute: "image", options: {post_url: admin_gallery_pics_path(f.object), gallery_id: gallery_id}
        else
          h4 "Please create the gallery first and then reload this page to add pictures!"
        end
      end

      f.actions
    end

    sidebar "Service Details", only: :show do
      panel "Overview" do
        attributes_table_for gallery do
          row :id
          row :num_of_pics
          row :created_at
          row :updated_at
        end
      end

      panel "Content Blocks" do
        gallery.content_blocks.each do |cb|
          div class: "detail_link_container" do
            link_to [:admin, cb], class: "detail_link" do
              cb.name
            end
          end
        end
      end
    end

    show title: :title do
      panel "Overview" do
        attributes_table_for gallery do
          row :title
          row :gallery_type
        end
      end

      gallery.pics.each do |pic|
        panel "Image" do
          div class: "speaker_img_contaier" do
            div class: "speaker_img_contaier" do
              if pic.image.exists?
                image_tag(pic.image.url(:md))
              else
                span do
                  "- no image -"
                end
              end
            end
          end
        end
      end

    end
  end
end
