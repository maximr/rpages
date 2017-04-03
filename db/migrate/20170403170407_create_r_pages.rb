class CreateRPages < ActiveRecord::Migration[5.0]
  def up
    create_table "cb_galleries", id: false, force: :cascade do |t|
      t.integer "content_block_id"
      t.integer "gallery_id"
      t.index ["content_block_id", "gallery_id"], name: "index_cb_galleries_on_content_block_id_and_gallery_id", using: :btree
      t.index ["content_block_id"], name: "index_cb_galleries_on_content_block_id", using: :btree
      t.index ["gallery_id"], name: "index_cb_galleries_on_gallery_id", using: :btree
    end

    create_table "ckeditor_assets", force: :cascade do |t|
      t.string   "data_file_name",               null: false
      t.string   "data_content_type"
      t.integer  "data_file_size"
      t.string   "data_fingerprint"
      t.integer  "assetable_id"
      t.string   "assetable_type",    limit: 30
      t.string   "type",              limit: 30
      t.integer  "width"
      t.integer  "height"
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
      t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
      t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree
    end

    create_table "content_blocks", force: :cascade do |t|
      t.string   "key"
      t.text     "content"
      t.string   "the_type",                      default: "text"
      t.integer  "priority",                      default: 0
      t.string   "css_class"
      t.string   "css_id"
      t.json     "parsed_content",                default: {}
      t.string   "content_image_file_name"
      t.string   "content_image_content_type"
      t.integer  "content_image_file_size"
      t.datetime "content_image_updated_at"
      t.string   "background_image_file_name"
      t.string   "background_image_content_type"
      t.integer  "background_image_file_size"
      t.datetime "background_image_updated_at"
      t.integer  "page_id"
      t.string   "block_spacing"
      t.string   "block_color"
      t.string   "content_position"
      t.string   "block_title"
      t.string   "block_template",                default: "none"
      t.boolean  "background_color_active",       default: false
      t.boolean  "remove_background_image",       default: false
      t.boolean  "remove_content_image",          default: false
      t.string   "block_width_breakpoints",       default: "12,12,12,12,12,12"
      t.string   "block_animation",               default: "fadeIn"
      t.integer  "block_animation_delay",         default: 500
      t.boolean  "block_animation_active",        default: true
      t.string   "block_text_color",              default: "main"
      t.boolean  "block_text_color_active",       default: false
      t.string   "template_animation_in",         default: "fadeIn"
      t.string   "template_animation_out",        default: "fadeOut"
      t.integer  "template_timing",               default: 7000
      t.string   "template_limiter",              default: "4,4,6,6,8,10"
      t.string   "video_file_name"
      t.string   "video_content_type"
      t.integer  "video_file_size"
      t.datetime "video_updated_at"
      t.boolean  "remove_video",                  default: false
      t.string   "video_preview_file_name"
      t.string   "video_preview_content_type"
      t.integer  "video_preview_file_size"
      t.datetime "video_preview_updated_at"
      t.boolean  "remove_video_preview",          default: false
      t.string   "link_type",                     default: "none"
      t.boolean  "video_processing"
      t.boolean  "video_preview_processing"
      t.boolean  "content_image_processing"
      t.boolean  "background_image_processing"
      t.text     "block_appearance",              default: ["none"],            array: true
      t.string   "associaton_model"
      t.integer  "associaton_ids",                default: [0],                 array: true
      t.boolean  "remove_gallery",                default: false
      t.index ["key"], name: "index_content_blocks_on_key", using: :btree
    end

    create_table "galleries", force: :cascade do |t|
      t.string   "title"
      t.string   "gallery_type"
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
      t.integer  "pics_id"
      t.index ["gallery_type"], name: "index_galleries_on_gallery_type", using: :btree
      t.index ["pics_id"], name: "index_galleries_on_pics_id", using: :btree
    end

    create_table "page_setts", force: :cascade do |t|
      t.integer "page_id"
      t.integer "sett_id"
      t.index ["page_id"], name: "index_page_setts_on_page_id", using: :btree
      t.index ["sett_id"], name: "index_page_setts_on_sett_id", using: :btree
    end

    create_table "pages", force: :cascade do |t|
      t.string   "name",                              null: false
      t.string   "headline",                          null: false
      t.string   "sub_headline"
      t.string   "slug"
      t.text     "body"
      t.integer  "author_id"
      t.datetime "created_at",                        null: false
      t.datetime "updated_at",                        null: false
      t.boolean  "remove_image",      default: false
      t.boolean  "primary_page",      default: false
      t.boolean  "active",            default: false
      t.integer  "content_blocks_id"
      t.string   "associaton_model"
      t.integer  "associaton_ids",    default: [0],                array: true
      t.json     "parsed_content",    default: {}
      t.index ["content_blocks_id"], name: "index_pages_on_content_blocks_id", using: :btree
    end

    create_table "pics", force: :cascade do |t|
      t.string   "title"
      t.string   "picture_type"
      t.integer  "position",           default: 0
      t.integer  "gallery_id"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.index ["picture_type"], name: "index_pics_on_picture_type", using: :btree
      t.index ["position"], name: "index_pics_on_position", using: :btree
    end

    create_table "sett_objects", force: :cascade do |t|
      t.integer  "priority",           default: 0
      t.string   "title"
      t.string   "object_type",        default: "none"
      t.string   "object_value",       default: "none"
      t.string   "object_modifier",    default: "none"
      t.text     "body"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.boolean  "remove_image",       default: false
      t.string   "icon_file_name"
      t.string   "icon_content_type"
      t.integer  "icon_file_size"
      t.datetime "icon_updated_at"
      t.boolean  "remove_icon",        default: false
      t.integer  "sett_id"
      t.boolean  "image_processing"
      t.boolean  "icon_processing"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.index ["object_modifier"], name: "index_sett_objects_on_object_modifier", using: :btree
      t.index ["object_type"], name: "index_sett_objects_on_object_type", using: :btree
      t.index ["object_value"], name: "index_sett_objects_on_object_value", using: :btree
      t.index ["priority"], name: "index_sett_objects_on_priority", using: :btree
      t.index ["title"], name: "index_sett_objects_on_title", using: :btree
    end

    create_table "setts", force: :cascade do |t|
      t.string   "sett_object",     default: "none"
      t.string   "sett_type",       default: "none"
      t.integer  "created_by",      default: 0
      t.integer  "updated_by",      default: 0
      t.boolean  "primary",         default: false
      t.integer  "sett_objects_id"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.index ["created_by"], name: "index_setts_on_created_by", using: :btree
      t.index ["primary"], name: "index_setts_on_primary", using: :btree
      t.index ["sett_object"], name: "index_setts_on_sett_object", using: :btree
      t.index ["sett_objects_id"], name: "index_setts_on_sett_objects_id", using: :btree
      t.index ["sett_type"], name: "index_setts_on_sett_type", using: :btree
      t.index ["updated_by"], name: "index_setts_on_updated_by", using: :btree
    end

    create_table "users", force: :cascade do |t|
      t.string   "email",                  default: "",    null: false
      t.string   "encrypted_password",     default: "",    null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,     null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.inet     "current_sign_in_ip"
      t.inet     "last_sign_in_ip"
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
      t.boolean  "admin",                  default: false
      t.string   "name"
      t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    end
  end

  def down
    drop_table :cb_galleries
    drop_table :ckeditor_assets
    drop_table :content_blocks
    drop_table :galleries
    drop_table :page_setts
    drop_table :pages
    drop_table :pics
    drop_table :sett_objects
    drop_table :setts
    drop_table :users
  end
end
