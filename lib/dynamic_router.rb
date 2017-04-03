class DynamicRouter
  def self.load
    Rails.application.routes.draw do
      if ActiveRecord::Base.connection.table_exists?('pages')
        Page.find_each do |pg|
          puts "Dynamic Router: Routing #{pg.name}"
          get "/#{pg.name}", :to => "pages#show", defaults: { name: pg.name }
        end
      else
        puts "Dynamic Router: skipping routing, because the table does not exist..."
      end
    end
  end

  def self.reload
    Rails.application.routes_reloader.reload!
  end
end