namespace :rpages do
  desc "This task creates the default setts"

  task create_default_setts: [:environment] do
    puts "Destroying all current objects"

    Sett.find_each.map {|s| s.update(primary: false)}
    Sett.destroy_all
    SettObject.destroy_all

    puts "Reseting counter sequence"

    Sett.reset_pk_sequence
    SettObject.reset_pk_sequence


    puts "Creating the default Setts"

    begin
      if Sett.count == 0
        Sett.create!([
          {sett_object: "main_settings", sett_type: "default", created_by: 1, updated_by: 1, primary: true, sett_objects_id: nil, name: "default_main"},
          {sett_object: "main_settings", sett_type: "meta", created_by: 1, updated_by: 1, primary: true, sett_objects_id: nil, name: "main_sets"},
          {sett_object: "navigation", sett_type: "menu", created_by: 1, updated_by: 1, primary: true, sett_objects_id: nil, name: "main_nav"},
          {sett_object: "navigation", sett_type: "collection", created_by: 1, updated_by: 1, primary: false, sett_objects_id: nil, name: "dd1"},
          {sett_object: "contact_links", sett_type: "collection", created_by: 1, updated_by: 1, primary: true, sett_objects_id: nil, name: "contact_links"},
          {sett_object: "footer", sett_type: "menu", created_by: 1, updated_by: 1, primary: true, sett_objects_id: nil, name: "main_footer"},
          {sett_object: "navigation", sett_type: "collection", created_by: 1, updated_by: 1, primary: false, sett_objects_id: nil, name: "footer_links"},
          {sett_object: "tracking", sett_type: "collection", created_by: 1, updated_by: 1, primary: true, sett_objects_id: nil, name: "page_tracking"}
        ])
      else
        puts "Setts allready existent...."
      end
    rescue
      puts "ERROR: Setts allready existent...."
    end

    puts "Creating the sett objects...."

    SettObject.create!([
      {priority: 0, title: "Twitter", object_type: "social_link", object_value: "0", object_modifier: "twitter", body: "<p>https://twitter.com/...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 5, image_processing: nil, icon_processing: nil},
      {priority: 0, title: "", object_type: "tracker", object_value: "0", object_modifier: "google_analytics", body: "<p>UA-...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 8, image_processing: nil, icon_processing: nil},
      {priority: 0, title: "pagetitle", object_type: "none", object_value: "3", object_modifier: "none", body: "<p>...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 2, image_processing: nil, icon_processing: nil},
      {priority: 0, title: "...", object_type: "row", object_value: "0", object_modifier: "text_row", body: "", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 6, image_processing: nil, icon_processing: nil},
      {priority: 1, title: "", object_type: "collection", object_value: "5", object_modifier: "social_links_row", body: "", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 6, image_processing: nil, icon_processing: nil},
      {priority: 1, title: "", object_type: "tracker", object_value: "0", object_modifier: "hubspot", body: "<p>...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 8, image_processing: nil, icon_processing: nil},
      {priority: 1, title: "description", object_type: "none", object_value: "3", object_modifier: "none", body: "<p>...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 2, image_processing: nil, icon_processing: nil},
      {priority: 1, title: "fav", object_type: "none", object_value: "3", object_modifier: "none", body: "", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 1, image_processing: nil, icon_processing: nil},
      {priority: 1, title: "logo", object_type: "none", object_value: "3", object_modifier: "none", body: "", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 1, image_processing: nil, icon_processing: nil},
      {priority: 1, title: "Instagram", object_type: "social_link", object_value: "0", object_modifier: "instagram", body: "<p>https://www.instagram.com/...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 5, image_processing: nil, icon_processing: nil},
      {priority: 2, title: "", object_type: "collection", object_value: "7", object_modifier: "links_row", body: "", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 6, image_processing: nil, icon_processing: nil},
      {priority: 2, title: "Facebook", object_type: "social_link", object_value: "0", object_modifier: "facebook", body: "<p>https://www.facebook.com/...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 5, image_processing: nil, icon_processing: nil},
      {priority: 2, title: "og-image", object_type: "none", object_value: "3", object_modifier: "none", body: "", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 2, image_processing: nil, icon_processing: nil},
      {priority: 2, title: "", object_type: "tracker", object_value: "0", object_modifier: "facebook", body: "<p>...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 8, image_processing: nil, icon_processing: nil},
      {priority: 3, title: "language", object_type: "none", object_value: "3", object_modifier: "none", body: "<p>en_EN</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 2, image_processing: nil, icon_processing: nil},
      {priority: 3, title: "", object_type: "tracker", object_value: "0", object_modifier: "google_adwords", body: "<p>...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 8, image_processing: nil, icon_processing: nil},
      {priority: 3, title: "Email", object_type: "social_link", object_value: "0", object_modifier: "envelope", body: "<p>mailto:...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 5, image_processing: nil, icon_processing: nil},
      {priority: 4, title: "", object_type: "social_link", object_value: "0", object_modifier: "youtube", body: "<p>http://www.youtube.com/...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 5, image_processing: nil, icon_processing: nil},
      {priority: 4, title: "", object_type: "tracker", object_value: "0", object_modifier: "mouseflow", body: "<p>...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 8, image_processing: nil, icon_processing: nil},
      {priority: 4, title: "keywords", object_type: "none", object_value: "3", object_modifier: "none", body: "<p>...,...,...</p>\r\n", image_file_name: nil, image_content_type: nil, image_file_size: nil, image_updated_at: nil, remove_image: false, icon_file_name: nil, icon_content_type: nil, icon_file_size: nil, icon_updated_at: nil, remove_icon: false, sett_id: 2, image_processing: nil, icon_processing: nil}
    ])
  end
end