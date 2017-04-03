module GalleryHelper
  def get_gallery_content(gallery, object)
    #return dummy content for now
    output = {}

    gallery.pics.each_with_index do |pic, i|
      output[i] = []
      if object.class.name.downcase == 'office'
        output[i] << object.headline
        output[i] << object.sub_headline
      else
        output[i] << object.head
        output[i] << object.sub_head
      end
    end

    output
  end
end