Rpages
=========

Rpages is intended to be an all in one out of the box solution for displaying content on the web to a broad number of devices (from mobile to VR). It is a rule based engine that uses certain behaviour paterns to controll the display of content.
It utilizes tools like Twitter Bootstrap v4, animate CSS, Font Awesome & many more. Using a fully dynamic backend it gives you the ability to display any content - in any way you like - without touching the source code.

The main intention is to reduce clutter as much as possible and use & combine the best tools and techniques available into a single solution.

Requirements
------------

### Ruby and Rails

Rpages is using Paperclip for image upload & processing (see [Paperclip](https://github.com/thoughtbot/paperclip)), so you have to meet certain requirements for that. It now requires Ruby version **>= 2.1** and Rails version **>= 4.2** (only if you're going to use Paperclip with Ruby on Rails.)

### Image Processor

[ImageMagick](http://www.imagemagick.org) must be installed and Rpages must have access to it. To ensure
that it does, on your command line, run `which convert` (one of the ImageMagick
utilities). This will give you the path where that utility is installed. For
example, it might return `/usr/local/bin/convert`.

If you're on Mac OS X, you'll want to run the following with [Homebrew] (http://www.brew.sh):

```
  brew install imagemagick
```

If you are dealing with pdf uploads or running the test suite, you'll also need
to install GhostScript. On Mac OS X, you can also install that using Homebrew:

```
  brew install gs
```

If you are on Ubuntu (or any Debian base Linux distribution), you'll want to run
the following with apt-get:

```
  sudo apt-get install imagemagick -y
```

### `file`

The Unix [`file` command](https://en.wikipedia.org/wiki/File_(command)) is required for content-type checking.
This utility isn't available in Windows, but comes bundled with Ruby [Devkit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit),
so Windows users must make sure that the devkit is installed and added to the system `PATH`.

**Manual Installation**

If you're using Windows 7+ as a development environment, you may need to install the `file.exe` application manually. The `file spoofing` system in Rpages relies on this; if you don't have it working, you'll receive `Validation failed: Upload file has an extension that does not match its contents.` errors.

To manually install, you should perform the following:

> **Download & install `file` from [this URL](http://gnuwin32.sourceforge.net/packages/file.htm)**

To test, you can use the image below:
![untitled](https://cloud.githubusercontent.com/assets/1104431/4524452/a1f8cce4-4d44-11e4-872e-17adb96f79c9.png)

Next, you need to integrate with your environment - preferably through the `PATH` variable, or by changing your `config/environments/development.rb` file

**PATH**

    1. Click "Start"
    2. On "Computer", right-click and select "Properties"
    3. In Properties, select "Advanced System Settings"
    4. Click the "Environment Variables" button
    5. Locate the "PATH" var - at the end, add the path to your newly installed `file.exe` (typically `C:\Program Files (x86)\GnuWin32\bin`)
    6. Restart any CMD shells you have open & see if it works

OR

**Environment**

    1. Open `config/environments/development.rb`
    2. Add the following line: `Paperclip.options[:command_path] = 'C:\Program Files (x86)\GnuWin32\bin'`
    3. Restart your Rails server

Either of these methods will give your Rails setup access to the `file.exe` functionality, thus providing the ability to check the contents of a file (fixing the spoofing problem)

### Video Processor

[FFMPEG](https://ffmpeg.org) must be installed and Rpages must have access to it. To ensure
that it does, on your command line, run `ffmpeg` (one of the FFMPEGs
utilities). This will give you the path where that utility is installed.

Please not to you need to install FFMPEG with some aditional libraries, in order to process mp4, ogv & webm formats.

For details on how to setup FFMPEG, please have a look at the [official documentation](https://ffmpeg.org/documentation.html).

Installation
------------

Rpages is distributed as a gem, which is how it should be used in your app.

Include the gem in your Gemfile:

```ruby
gem "rpages", github: 'maximr/rpages'
```

For now you need to use to git repo directory, because this gem is not registered with ruby gems yet...

If you're trying to use features that don't seem to be in the latest released gem, but are
mentioned in this README, then you probably need to specify the master branch if you want to
use them. This README is probably ahead of the latest released version if you're reading it
on GitHub.

---

Quick Start
-----------

## Make sure to run every step!

### Basis Setup

I supposed you have allready created a Database for your App. If not, make sure to run first

```ruby
rails db:create
```

### Migrations

-> Run this line to create the migration file required to setup your database

```ruby
rails g rpages:add_migrations
```

-> Run this line to migrate your database with the new migration file

```ruby
rails db:migrate
```

### Config & Admin User

-> Run this line to create the default configuration file in config/... (Please make sure to rename it, in order for it to work properly)

```ruby
rails rpages:create_default_config
```

-> Run this line to create the default admin account you need to access the backend

```ruby
rails rpages:create_admin_user
```

### Setts

-> Run this line to create all of the default setts that are required by the application (see setts for details)

```ruby
rails rpages:create_default_setts
```

### Assets
-> Run this - it will create most of the default assets & files required by the application

```ruby
rails rpages:create_asset_files
```

### Javascript

-> Add these lines to your application js file:

```Javascript
  //= require rpages_admin

  $map_key = 'Your_Google_Maps_Api_Key';
  $brand_primary = 'Your_Brand_Color';
```

### CSS

-> Add the following lines to your application.scss file:

```CSS
  $brand-secondary: #000; //change this to a value of your own
  @import "variables"; //if you have a variables file - to redifine the rpages variables
  @import "rpages/rpages";
```

### Controllers
-> Add these lines to your application controller

```ruby
include RpagesHelper

helper_method :get_device_data
helper_method :is_mobile?
```

### Models

If you want to be able to include dynamic models & database entries within Rpages, you should add following code in your *model*.rb file:

```ruby
class YourModel < ApplicationRecord
  include RpagesSelectable
end
```

Note: If you want to overwrite any of the Sass variables defined within Rpages, please use a custom variables definition.

Contributing
-------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

License
-------

Rpages is Copyright © 2016-2017 Maxim Roubintchik, inc. It is free software, and may be
redistributed under the terms specified in the MIT-LICENSE file.

About Rpages
----------------

Rpages is maintained and funded by Maxim Roubintchik.