module RemoveableAttachments
  extend ActiveSupport::Concern

  included do
    before_save :remove_logic
    before_destroy :remove_all_attachments

    IMAGE_STYLES ||= { 
      thumb: "75x75#",
      mobile_xs: "480x800>",
      mobile_sm: "720x1024>",
      mobile_md: "640x960>",
      mobile_ll: "640x1136",
      mobile_xl: "1080x1920>",
      tablet_xs: "1280x800>",
      tablet_xl: "1536x2048>",
      xs: "544x340>", 
      sm: "767x479>", 
      md: "991x619>", 
      ll: "1300x819>", 
      hd: "1920x1080>", 
      xl: "2880x1800" 
    }
    
  end

  def get_paperclip_attachments
    raw_array = self.methods.select { |i| i.to_s.include?('file_name=') }
    raw_array.present? ? raw_array.map { |i| i.to_s.split('_file').first } : []
  end

  private

  def remove_logic
    get_paperclip_attachments.each do |att|
      if self.send("remove_#{att}")
        self.write_attribute("remove_#{att}", false)
        self.send(att).destroy
        self.send(att).clear
      end
    end
  end

  def remove_all_attachments
    get_paperclip_attachments.each do |att|
      self.send(att).destroy
      self.send(att).clear
    end
  end
end
