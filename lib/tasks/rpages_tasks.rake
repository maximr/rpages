namespace :rpages do
  task create_default_config: [:environment] do
    puts "RPAGES: Creating default config file - please rename it to application.yml or add the content to your existing application.yml"
    source = File.join(Gem.loaded_specs["rpages"].full_gem_path, "config", "default_application.yml")
    target = File.join(Rails.root, "config", "default_application.yml")
    FileUtils.cp_r source, target
  end

  task create_admin_user: [:environment] do
    puts "RPAGES: Creating the admin user with a random password"
    random_pass = (0...50).map { ('a'..'z').to_a[rand(16)] }.join
    puts "Account Name: root@domain.com"
    puts "Pass: #{random_pass}"
    puts "please change the password!"

    User.create!(email: 'root@domain.com', password: random_pass, password_confirmation: random_pass, name: 'root')
  end

  task create_asset_files: [:environment] do
    puts "RPAGES: Creating asset files"

    {:javascripts => ['active_admin.js'], :stylesheets => ['active_admin.scss']}.each do |k,v|
      v.each do |file|
        puts "Creating file #{file} in #{k}..."

        source = File.join(Gem.loaded_specs["rpages"].full_gem_path, "app", "assets", k.to_s, file)
        target = File.join(Rails.root, "app", "assets", k.to_s, file)
        FileUtils.cp_r source, target
      end
    end

    puts "RPAGES: Copying image files..."

    source = Gem.loaded_specs["rpages"].full_gem_path + "/public" + "/images"
    target = File.join(Rails.root, "public", "images")
    FileUtils.cp_r source, target
  end
end

