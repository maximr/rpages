module PagesHelper
  def get_video_settings(slide)
    {mp4: slide.video.url(:mp4), webm: slide.video.url(:webm), ogv: slide.video.url(:ogv), poster: slide.video_preview.url(:hd)}.to_json
    #url_base = "https://holodeckvr.s3.amazonaws.com/videos/holodeckvr_video"
    #todo: make this work on heroku
    #{mp4: "#{url_base}.mp4", webm: "#{url_base}.webm", ogv: "#{url_base}.ogv", poster: slide.video_preview.url(:hd)}.to_json
  end

  def build_content_block_classes(slide)
    out = "slide slide_flex slide_flex_center content_slide"
    out << " slide_with_background" if slide.background_image.present?
    out << " #{slide.content_position}"
    out << " #{slide.block_spacing}"
    out << " #{slide.get_content_block_template_class}"
    out << " #{slide.get_content_block_appearance_class}"
    out << " slide--video" if slide.has_video?
    out << " slide--no_margin slide--no_padding_bottom" if slide.has_gallery?
    #out << " slide--no_margin" unless slide.has_media?
    out << " #{slide.css_class}" if slide.has_css_class?
    out
  end

  def build_content_block_style(slide)
    out = ""
    out << "background-color: #{slide.get_block_color} !important;" if slide.get_block_color
    out << "color: #{slide.get_block_text_color} !important;" if slide.get_block_text_color
    out << slide.css_id.strip.html_safe if slide.has_style?
    out
  end

  def get_template(slide)
    template_url = 'content_blocks/'

    if slide.is_default_template?
      template_url << 'default_template'
    else
      template_url << slide.get_content_block_template
    end

    template_url
  end

  def get_reveal_settings(slide)
    { flex: true, 
      delay: slide.template_timing, 
      blockable: true, 
      hideAnimation: slide.template_animation_out, 
      blockOnHover: true, 
      withArrows: true, 
      revealAnimation: slide.template_animation_in, 
      limit: slide.get_section_number_hash
    }.to_json
  end

  def generate_reveal_data(slide, block)
    output = {}
    output[:reveal_head] = block['head'] if block['head'].present?
    output[:reveal_desc] = block['desc'] if block['desc'].present?
    #output[:reveal_body] = block['body'] if block['body'].present?

    if block['img'].present?
      output[:reveal_img] = slide.get_image_url block['img']
    end
    
    output.to_json
  end

  def generate_style_data
    if @sett_style && @sett_style.get_objects.present?
      output = {}
      @sett_style.get_objects.each do |font|
        if font.type_is?('font')
          selector = font.object_modifier.to_s.downcase.to_sym
          output[selector] = {} unless output[selector].present?
          output[selector][:families].present? ? output[selector][:families] << sanitize(font.body, tags: []).gsub(/[\r\n]/, '') : output[selector][:families] = [sanitize(font.body, tags: []).gsub(/[\r\n]/, '')]
        end
      end
    else
      output = {
        google: {
          families: ['Open Sans:300i,400,700']
        }
      }
    end

    output.to_json
  end

  def generate_font_style
    style = @sett_style ? @sett_style.get_objects.where(object_type: 'font-style') : nil
    style.present? ? "#{style.first.object_modifier.to_s.chomp(';')} !important;" : "font-family: 'Open Sans', sans-serif !important;"
  end

  def render_smart_content(slide, item, index_num, custom_width=true, single_item=99999)
    raw_items = slide.get_json_content(ActionController::Base.helpers.strip_tags(item))
    output = []

    if raw_items.is_a?(Array)
      raw_items.each_with_index do |raw_item, e|
        class_data = "col-xs-12 #{'col-sm-6 col-md-4 col-lg-4 col-ll-3' if custom_width && raw_items.count <= 3} indv-item"
        class_data << " popup-trigger" if slide.is_inline_link? && single_item == 99999

        buffer = ActionController::Base.helpers.content_tag(:div, class: class_data, data: {
            aparams: {num: index_num, id: slide.id, sub_num: e}.to_json,
              target: '#main_modal', toggle: "#{'modal' if slide.is_inline_link? && single_item == 99999}"} ) do
          sub_out = []

          if raw_item.is_a?(Array)
            raw_item.each do |sub_item|
              sub_out << ActionController::Base.helpers.content_tag(sub_item['tag'], sub_item['content'].html_safe, class: sub_item['class'], title: sub_item['title'])
            end
          else
            sub_out << raw_item
          end

          sub_out.join('').html_safe
        end

        output << buffer.html_safe if single_item == 99999 || (single_item != 99999 && single_item == e)
      end
    else
      output << item.html_safe
      #content_tag(:h4, "No Items")  
    end

    output.join('').html_safe
  end

  def get_gallery_content(gallery, object)
    output = {}

    gallery.pics.each_with_index do |pic, i|
      output[i] = []
      output[i] << object.key
      output[i] << object.content.html_safe
    end

    output
  end

  def generate_cta_styles(slide)
    out = "border-color: " 
    out << slide.get_block_text_color ? slide.get_block_text_color : 'inherit'
    out << ";color: "
    out << slide.get_block_text_color ? slide.get_block_text_color : 'inherit'
    out << ";"
    out
  end

  # def link_item_functionality(slide, block, content)
  #   if slide.is_normal_link?
  #     link_to(strip_tags(block['body'])) do
  #       content
  #     end
  #   elsif slide.is_inline_link?

  #   end
  # end
end