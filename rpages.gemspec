# -*- encoding: utf-8 -*-
# stub: rpages 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rpages".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Maxim Roubintchik".freeze]
  s.date = "2017-06-21"
  s.description = "Here comes the description....".freeze
  s.email = ["maxim@roubintchik.com".freeze]
  s.files = ["lib/active_record".freeze, "lib/active_record/add_reset_pk_sequence_to_base.rb".freeze, "lib/dynamic_router.rb".freeze, "lib/rpages".freeze, "lib/rpages.rb".freeze, "lib/rpages/admin".freeze, "lib/rpages/admin/footer.rb".freeze, "lib/rpages/admin/gallery.rb".freeze, "lib/rpages/admin/page.rb".freeze, "lib/rpages/admin/pic.rb".freeze, "lib/rpages/admin/sett.rb".freeze, "lib/rpages/engine.rb".freeze, "lib/rpages/version.rb".freeze, "lib/tasks".freeze, "lib/tasks/rpages_tasks.rake".freeze, "lib/tasks/setts.rake".freeze, "vendor/assets".freeze, "vendor/assets/files".freeze, "vendor/assets/files/ckeditor".freeze, "vendor/assets/files/ckeditor/skins".freeze, "vendor/assets/files/ckeditor/skins/minimalist".freeze, "vendor/assets/files/ckeditor/skins/minimalist/dialog.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/dialog_ie.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/dialog_ie7.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/dialog_ie8.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/dialog_iequirks.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/editor.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/editor_gecko.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/editor_ie.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/editor_ie7.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/editor_ie8.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/editor_iequirks.css".freeze, "vendor/assets/files/ckeditor/skins/minimalist/icons.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/icons_hidpi.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/arrow.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/close.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/hidpi".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/hidpi/close.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/hidpi/lock-open.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/hidpi/lock.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/hidpi/refresh.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/lock-open.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/lock.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/images/refresh.png".freeze, "vendor/assets/files/ckeditor/skins/minimalist/readme.md".freeze, "vendor/assets/files/ckeditor/skins/minimalist/skin.js".freeze, "vendor/assets/javascripts".freeze, "vendor/assets/javascripts/jquery.counterup.min.js".freeze, "vendor/assets/javascripts/jquery.fitvids.js".freeze, "vendor/assets/javascripts/jquery.flip.min.js".freeze, "vendor/assets/javascripts/jquery.flip.min.js.map".freeze, "vendor/assets/javascripts/jquery.mobile-events.min.js".freeze, "vendor/assets/javascripts/jquery.scrollstop.js".freeze, "vendor/assets/javascripts/jquery.tabSlideOut.js".freeze, "vendor/assets/javascripts/jquery.vide.js".freeze, "vendor/assets/javascripts/particles.min.js".freeze, "vendor/assets/javascripts/waypoint.min.js".freeze, "vendor/assets/javascripts/webfontloader.js".freeze, "vendor/assets/stylesheets".freeze]
  s.homepage = "https://github.com/maximr/rpages".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "ContentManagement for Rails Apps".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, ["~> 5.0"])
      s.add_runtime_dependency(%q<stringex>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<bootstrap>.freeze, ["~> 4.0.0.alpha6"])
      s.add_runtime_dependency(%q<rails-assets-tether>.freeze, [">= 1.1.0"])
      s.add_runtime_dependency(%q<font-awesome-rails>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<faker>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<annotate>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<paperclip>.freeze, ["~> 5.0.0"])
      s.add_runtime_dependency(%q<paperclip-av-transcoder>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<devise>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<figaro>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<browser>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, ["~> 5.0"])
      s.add_dependency(%q<stringex>.freeze, [">= 0"])
      s.add_dependency(%q<bootstrap>.freeze, ["~> 4.0.0.alpha6"])
      s.add_dependency(%q<rails-assets-tether>.freeze, [">= 1.1.0"])
      s.add_dependency(%q<font-awesome-rails>.freeze, [">= 0"])
      s.add_dependency(%q<faker>.freeze, [">= 0"])
      s.add_dependency(%q<annotate>.freeze, [">= 0"])
      s.add_dependency(%q<paperclip>.freeze, ["~> 5.0.0"])
      s.add_dependency(%q<paperclip-av-transcoder>.freeze, [">= 0"])
      s.add_dependency(%q<devise>.freeze, [">= 0"])
      s.add_dependency(%q<figaro>.freeze, [">= 0"])
      s.add_dependency(%q<browser>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["~> 5.0"])
    s.add_dependency(%q<stringex>.freeze, [">= 0"])
    s.add_dependency(%q<bootstrap>.freeze, ["~> 4.0.0.alpha6"])
    s.add_dependency(%q<rails-assets-tether>.freeze, [">= 1.1.0"])
    s.add_dependency(%q<font-awesome-rails>.freeze, [">= 0"])
    s.add_dependency(%q<faker>.freeze, [">= 0"])
    s.add_dependency(%q<annotate>.freeze, [">= 0"])
    s.add_dependency(%q<paperclip>.freeze, ["~> 5.0.0"])
    s.add_dependency(%q<paperclip-av-transcoder>.freeze, [">= 0"])
    s.add_dependency(%q<devise>.freeze, [">= 0"])
    s.add_dependency(%q<figaro>.freeze, [">= 0"])
    s.add_dependency(%q<browser>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
