class ContentBlock < ApplicationRecord
  include RemoveableAttachments
  include CollectionModel
  include AssociationModel
  
  belongs_to :page
  has_and_belongs_to_many :galleries, join_table: "cb_galleries"
  
  accepts_nested_attributes_for :page
  accepts_nested_attributes_for :galleries, reject_if: :all_blank, allow_destroy: true

  #before_save :store_selection
  before_save :clean_block_content
  before_save :parse_and_store_content
  before_save :remove_gallery_logic
  after_touch :parse_and_store_content_with_save

  ContentBlockTypes = ['pagecontent', 'eventdetails']

  default_scope { order('priority ASC') }

  scope :intro, -> { self.where(:block_template => BLOCK_TEMPLATES[2]) }

  has_attached_file :content_image, styles: { thumb: "75x75#", xs: "200x200#", md: "500>",  lg: "800>", ll: "1000>"}
  has_attached_file :background_image, styles: IMAGE_STYLES
  has_attached_file :video, styles: {
    mp4: {
      format: "mp4",
      convert_options: {
        output: {
          an: nil
        }
      }
    },
    ogv: {
      format: "ogv",
      convert_options: {
        output: {
          an: nil
        }
      }
    },
    webm: {
      format: "webm",
      convert_options: {
        output: {
          an: nil
        }
      }
    },
  }, :processors => [:transcoder]
  has_attached_file :video_preview, styles: IMAGE_STYLES

  validates_attachment_content_type :content_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :background_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :video, content_type: /\Avideo\/.*\Z/
  validates_attachment_content_type :video_preview, content_type: /\Aimage\/.*\z/

  process_in_background :content_image
  process_in_background :background_image
  process_in_background :video
  process_in_background :video_preview

  validate :correct_section_limiter
  validate :correct_block_limiter

  DEFAULT_SELECTOR = {
    'Stream': :name
  }

  DEFAULT_CHILD = {
    'Stream': :talks
  }

  DEFAULT_CHILD_CLASS = {
    'Stream': "Talk"
  }

  SPACINGS = {
    'None': '',
    'Min': 'slide--min',
    '10%': 'slide--10',
    '20%': 'slide--20',
    '30%': 'slide--30',
    '40%': 'slide--40',
    'Half': 'slide--half',
    '60%': 'slide--60',
    '70%': 'slide--70',
    '80%': 'slide--80',
    '90%': 'slide--90',
  }

  CONTENT_POSITIONS = {
    'No Image': 'image-none',
    'Left Image': 'image-left',
    'Right Image': 'image-right'
  }

  BLOCK_TYPES = %w{ pagecontent }

  BLOCK_TEMPLATES = %w{ none intro counter flipcard reveal media schedule map iframe }
  BLOCK_TEMPLATE_CLASSES = ['', 'intro_slide', 'counter_slide', 'flipcard_slide', '', 'media_slide', 'schedule_slide', 'map_slide', 'iframe_slide']

  BLOCK_APPEARANCES = %w{ none black gray primary secondary content_left content_bottom content_right content_top fade1 fade2 fade3 cutoff_top cutoff_bottom no_margin no_padding_bottom content_triangle content_background content_box 3d_box text_size_0.5 text_size_1.5 text_size_2 text_size_3 }
  BLOCK_APPEARANCE_CLASSES = ['', 'slide--black_back', 'slide--gray_back', 'slide--main_back', 
                              'slide--secondary_back', 'slide_flex_left', 'slide_flex_bottom', 'slide_flex_right', 'slide_flex_top', 'fade-1', 'fade-2', 'fade-3', 
                              'slide--vertial_top', 'slide--vertial_bottom', 'slide--no_margin', 'slide--no_padding_bottom', 'slide--content_triangle', 'background_block', 'offset_content', 'three_d_slide', 'slide--font_05', 'slide--font_15', 'slide--font_20', 'slide--font_30']

  ANIMATIONS = %w{ bounce flash pulse rubberBand shake headShake swing tada wobble jello bounceIn bounceInDown bounceInLeft bounceInRight bounceInUp bounceOut bounceOutDown bounceOutLeft bounceOutRight bounceOutUp 
                   fadeIn fadeInDown fadeInDownBig fadeInLeft fadeInLeftBig fadeInRight fadeInRightBig fadeInUp fadeInUpBig fadeOut fadeOutDown fadeOutDownBig fadeOutLeft fadeOutLeftBig fadeOutRight fadeOutRightBig 
                   fadeOutUp fadeOutUpBig flipInX flipInY flipOutX flipOutY lightSpeedIn lightSpeedOut rotateIn rotateInDownLeft rotateInDownRight rotateInUpLeft rotateInUpRight rotateOut rotateOutDownLeft rotateOutDownRight 
                   rotateOutUpLeft rotateOutUpRight hinge rollIn rollOut zoomIn zoomInDown zoomInLeft zoomInRight zoomInUp zoomOut zoomOutDown zoomOutLeft zoomOutRight zoomOutUp slideInDown slideInLeft slideInRight 
                   slideInUp slideOutDown slideOutLeft slideOutRight slideOutUp
                  }

  LINK_TYPES = %w{ none default new_page popup }

  ASSOCIATION_TYPES = %w{ text image video method }

  #class methods
  def self.get_all(type)
    self.where(the_type: type)
  end

  def self.get_default_collection
    {'none': 0}.merge(self.pluck(:block_title,:id).each_with_object(Hash.new(0)) { |e, a| a[e[0].to_s] = e[1] })
  end

  def get_valid_associations
    ApplicationRecord.descendants.map(&:name).select {|i| i unless i == "Event" }
  end

  #instance methods
  #helpers

  def spacing_is?(selector)
    SPACINGS[selector.to_sym] == block_spacing
  end

  def content_position_is?(selector)
    CONTENT_POSITIONS[selector.to_sym] == content_position
  end

  def get_block_color
    block_color if background_color_active
  end

  def get_block_text_color
    block_text_color if block_text_color_active
  end

  def has_css_class?
    css_class.present?
  end

  def has_style?
    css_id.present?
  end

  def get_block_title
    "[#{block_template}] #{block_title}"
  end

  def has_video?
    video.exists?
  end

  def has_image?
    background_image.exists?
  end

  def has_gallery?
    galleries.present?
  end

  def has_media?
    has_video? || has_image?
  end

  #templating

  def get_content_block_template
    @block_template ||= self.block_template
  end

  def get_content_block_template_class
    BLOCK_TEMPLATE_CLASSES[BLOCK_TEMPLATES.index(get_content_block_template)]
  end

  def get_content_block_appearance_class
    self.block_appearance.map { |ap| BLOCK_APPEARANCE_CLASSES[BLOCK_APPEARANCES.index(ap)] }.join(' ').strip if self.block_appearance.present?
  end

  def is_default_template?
    get_content_block_template == BLOCK_TEMPLATES.first
  end

  def is_normal_link?
    self.link_type == LINK_TYPES[1] || self.link_type == LINK_TYPES[2]
  end

  def is_inline_link?
    self.link_type == LINK_TYPES[3]
  end

  # parse content

  def get_custom_content_items
    !self.parsed_content || self.parsed_content == 'false' ? [] : get_json_content(self.parsed_content)
  end

  def parse_custom_content_items
    output = []
    parsed_content = get_custom_content_blocks

    return false unless parsed_content.present?

    if has_connected_object?
      self.get_association.each do |ass|
        item = {}

        item[:head] = clean_content(parsed_content.css('.col-headline').first.content, ass)
        item[:desc] = clean_content(select_and_join(parsed_content.css('.col-description')), ass)
        item[:body] = clean_content(select_and_join(parsed_content.css('.col-body')), ass)
        item[:img]  = clean_content(parsed_content.css('.col-image').first.content, ass)

        output << item
      end
    else
      get_custom_content_blocks.each do |ass|
        item = {}

        item[:head] = get_headline(ass)
        item[:desc] = get_description(ass)
        item[:body] = get_body(ass)
        item[:img] = get_image(ass)

        output << item
      end
    end

    output
  end

  def select_and_join(selector)
    selector.first.css('p, h2, h3, h4, h5').map(&:to_s).join('')
  end

  def get_custom_content_blocks
    Nokogiri::HTML(self.content).css('.custom-content-row')
  end

  def get_headline(block)
    clean_content block.css('.col-headline').first.content
  end

  def get_description(block)
    clean_content select_and_join(block.css('.col-description'))
  end

  def get_body(block)
    clean_content select_and_join(block.css('.col-body'))
  end

  def get_image(block)
    url = get_image_basic_url(block)
    if url.present?
      image_name = parse_image_name(url)
      asset = Ckeditor::Picture.where(data_file_name: image_name)
      asset.first if asset.present?
    end
  end

  def get_image_url(img)
    if img.is_a?(Hash)
      Ckeditor::Picture.find(img['asset']['id'].to_i).url
    else
      img
    end
  end

  def get_image_basic_url(block)
    block.css('.col-image img').first.attributes['src'].value if block.css('.col-image img').present?
  end

  def parse_image_name(url)
    url.split('/').last
  end

  def clean_content(content, objekt=nil)
    if has_connected_object?
      parse_object_fields content.gsub(/[\r\n]/, ''), objekt
    else
      content.gsub(/[\r\n]/, '')
    end
  end

  def get_json_content(json)
    valid_json?(json) ? JSON.parse(json) : json
  end

  def valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end
  end

  # dynamic db objects

  def has_connected_object?
    self.get_association.present?
  end

  def parse_object_fields(content, objekt)
    scanned_content = content.scan(/(\[(.*?)\])/im)

    if !scanned_content.empty?
      scanned_content.each_with_index do |item, i|
        raw_data = item.last.to_s.downcase
        data_type = raw_data.split(':').present? ? raw_data.split(':').first : ''

        if is_valid_association_type?(data_type)
          data_field = raw_data.split(':').count >= 2 ? raw_data.split(':').last : ''
          data_field = raw_data.split(':')[1] if raw_data.split(':').count > 2

          if is_text_association?(data_type)
            content.sub! /(\[(.*?)\])/im, get_association_content(data_field, objekt)
          elsif is_image_association?(data_type)
            out = get_association_content(data_field, objekt)
            img_url = raw_data.split(':').count > 2 ? out.url(raw_data.split(':').last.to_s.strip) : out.url
            if scanned_content.count > 1
              content = content.sub! /(\[(.*?)\])/im, ActionController::Base.helpers.image_tag(img_url)
            else
              content = img_url
            end
          elsif is_method_association?(data_type)
            method_output = raw_data.split(':').count > 2 ? get_association_content(data_field, objekt, raw_data.split(':').last) : get_association_content(data_field, objekt)
            content.sub! /(\[(.*?)\])/im, (method_output.is_a?(String) ? method_output : method_output.to_json)
          end
        end
      end
    end

    content
  end

  def is_valid_association_type?(association_type)
    ContentBlock::ASSOCIATION_TYPES.include?(association_type)
  end

  def is_text_association?(association_type)
    association_type == 'text'
  end

  def is_image_association?(association_type)
    association_type == 'image'
  end

  def is_video_association?(association_type)
    association_type == 'video'
  end

  def is_method_association?(association_type)
    association_type == 'method'
  end

  def get_association_content(content, objekt, params=nil)
    if objekt.has_attribute?(content) || objekt.respond_to?(content)
      params.nil? ? objekt.send(content) : objekt.send(content, params)
    else
      ''
    end
  end

  #cols & limiters

  def get_block_limiter_num
    get_limiter_array(get_block_limiter_array).count
  end

  def get_block_limiter_array
    @bla ||= get_limiter_array(block_width_breakpoints)
  end

  def get_block_limiter_hash
    get_limiter_hash(get_block_limiter_array)
  end

  def get_block_cols
    get_block_limiter_hash.map{|k,v| "col-#{k}-#{v}"}.join(' ')
  end


  def get_section_limiter_num
    get_limiter_array(get_section_limiter_array).count
  end

  def get_section_limiter_array
    @sla ||= get_limiter_array(template_limiter)
  end

  def get_section_breakpoint_array
    get_breakpoint_array(get_section_limiter_array)
  end

  def get_section_limiter_hash
    get_limiter_hash(get_section_breakpoint_array)
  end

  def get_section_number_hash
    get_limiter_hash(get_section_limiter_array)
  end

  def get_section_cols
    get_section_limiter_hash.map{|k,v| "col-#{k}-#{v}"}.join(' ')
  end

  def get_content
    @request_params ||= JSON.parse(parsed_content)
  end

  #other stuff

  private

  def get_breakpoint_array(sel)
    sel.map {|t| (12 / t) < 1 ? 1 : (12 / t) }
  end

  def get_limiter_array(sel)
    sel.to_s.strip.split(',').map(&:to_i)
  end

  def get_limiter_hash(t)
    {xs: t[0], sm: t[1], md: t[2], lg: t[3], ll: t[4], xl: t[5]}
  end

  def get_limiter_num(sel)
    sel.count
  end

  def correct_section_limiter
    errors.add(:template_limiter, 'has to be exactly 6 numbers.') unless get_section_limiter_num == 6
  end

  def correct_block_limiter
    errors.add(:block_width_breakpoints, 'has to be exactly 6 numbers.') unless get_block_limiter_num == 6
  end

  def clean_block_content
    content = content.gsub(/[\r\n]/, '') if content.present?
  end

  def parse_and_store_content
    self.parsed_content = self.parse_custom_content_items.to_json
  end

  def parse_and_store_content_with_save
    self.parsed_content = self.parse_custom_content_items.to_json
    self.save
  end

  def remove_gallery_logic
    if remove_gallery
      self.remove_gallery = false
      self.galleries.delete(self.galleries.first)
    end
  end
end
