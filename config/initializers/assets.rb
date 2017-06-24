# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( rpages.js rpages_admin.js webfontloader.js jquery.counterup.min.js particles.min.js jquery.flip.min.js jquery.vide.js  )
Rails.application.config.assets.precompile += %w( active_admin_multi_upload/jquery_upload.css ckeditor/config.js jquery.fitvids.js )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/thumbs/pdf.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/thumbs/jpg.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/thumbs/png.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/thumbs/gif.gif )
Rails.application.config.assets.precompile += %w( ckeditor/filebrowser/thumbs/unknown.gif )
Rails.application.config.assets.precompile += %w( vrview.js three.js embed.js )