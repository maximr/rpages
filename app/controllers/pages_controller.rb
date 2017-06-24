class PagesController < ApplicationController
  layout nil, only: [:vrview]
  layout 'rpages', except: [:vrview]
  include PagesHelper

  def root
    redirect_to "#{Page.get_primary}", status: 301
  end

  def show
    @page         = Page.active.find_by_slug(params[:name])

    if @page
      @slides       =  @page.get_slide_containers
      @sett_main    = @page.get_sett_x('main_settings', 'default')
      @sett_meta    = @page.get_sett_x('main_settings', 'meta')
      @sett_nav     = @page.get_sett_x('navigation', 'menu')
      @sett_footer  = @page.get_sett_x('footer', 'menu')
      @sett_track   = @page.get_sett_x('tracking', 'collection')
      @sett_style   = @page.get_sett_x('style', 'none')
      @assocation   = @page.get_association
    end

    redirect_to not_found_path unless @page
  end

  def not_found
    render inline: "<h1>Nothing here...</h1>"
  end

  def static
    @page = StaticPage.find(params[:id])
  end

  def file
    #render file: params.values.join('.')
    filename = "#{params[:id]}.#{params[:format]}"
    
    send_file "#{Rails.root}/public/files/#{filename}", type: 'video/mp4', disposition: 'inline'
  end

  def get_selection
    @output = {status: 500, content: {}}

    @the_model = params[:type].to_s.titleize.constantize

    if @the_model
      @output[:status] = 200
      @output[:selection] = @the_model.get_selectable_collection
    end

    render json: @output.to_json, status: @output[:status]
  end

  def get_cb_content
    @block = ContentBlock.find(params[:id])

    if @block
      if params[:num].present?
        @content = @block.get_custom_content_items.drop(params[:num].to_i).first
        @content = render_smart_content(@block, @content['body'], params[:num].to_i, false, params[:sub_num].to_i) if params[:sub_num].present?

        if @content
          render inline: params[:sub_num].present? ? @content.html_safe : @content['body'].html_safe
        else
          render inline: "<h2>No content here...</h2>"
        end
      else
        render inline: @block.content.html_safe
      end
    else
      render inline: "<h2>Nothing here...</h2>"
    end
  end

  def vrview

  end

  #private
    # Use callbacks to share common setup or constraints between actions.
end
