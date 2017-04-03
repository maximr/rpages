if defined?(ActiveAdmin)
  ActiveAdmin.register Pic do
    belongs_to :gallery

    controller do
      def create
        super do |format|
          if @pic.save
            format.html { render :json => [@pic.to_jq_upload].to_json, 
              :content_type => 'text/html',
              :layout => false
            }

            format.json { render json: {files: [@pic.to_jq_upload] }}
          else
            format.json { render json: @pic.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    permit_params :id, :title, :image, :position
    
    allows_multi_upload(mounted_uploader: :image)
  end
end