module Rpages
  class Engine < ::Rails::Engine
    isolate_namespace Rpages

    #not beatiful - but it should work....
    require 'rubygems'
    require 'stringex_lite'
    require 'devise'
    require 'figaro'

    #config.autoload_paths += Dir[Rpages.get_root.join('app', 'models', '{**}')]
    config.assets.precompile += Ckeditor.assets

    initializer :add_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # Add interface for Active Admin (Pro)
    # @see http://activeadmin.info
    # @see http://github.com/codelation/activeadmin_pro
    if defined?(ActiveAdmin)
      initializer :rpages do
        ActiveAdmin.application.load_paths.unshift File.join(File.expand_path("../..", __FILE__), "rpages", "admin")
        
        module ActiveAdmin::ViewHelpers
          include ActiveAdminHelper
        end
      end
    end
  end
end


# config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
# config.assets.precompile += Ckeditor.assets
# config.autoload_paths << Rails.root.join('lib')