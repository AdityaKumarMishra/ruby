# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( managers.js )
Rails.application.config.assets.precompile += %w( course-recommender.js sign-up-component.js homepage-component.js comparison-modal.js)
Rails.application.config.assets.precompile += %w( video-js.swf vjs.eot vjs.svg vjs.ttf vjs.woff )
Rails.application.config.assets.precompile += %w( museo-slab.eot museo-slab.svg museo-slab.ttf museo-slab.woff )
Rails.application.config.assets.precompile += %w( museo.eot museo.woff2 museo.ttf museo.woff )
Rails.application.config.assets.precompile += %w( filterrific/filterrific-spinner.gif )
Rails.application.config.assets.precompile += %w( comparison-modal.js )
Rails.application.config.assets.precompile += %w( gamsatfeedback-component.js )
Rails.application.config.assets.precompile += %w( student_page.css )
Rails.application.config.assets.precompile += %w( student_page.js )
Rails.application.config.assets.precompile += %w( calender.js )
Rails.application.config.assets.precompile += %w( ratyrate.js jquery.validate.js)
Rails.application.config.assets.precompile += %w( ckeditor/*)
