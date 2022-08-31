Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # Set this to false for faster rendering
  # Set to true when we start front-end development/debug
  config.assets.debug = false
  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true
  config.assets.digest = true
  config.assets.quiet = true
  config.assets.raise_runtime_errors = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.action_mailer.asset_host = 'http://localhost:3000'
  config.action_mailer.default_url_options = {host: 'localhost', port: 3000}

  # config.action_mailer.delivery_method = :smtp

  # These are the company wide S3 credentials
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_protocol => 'http',
    :bucket => ENV['S3_BUCKET_NAME'],
    :url => ':s3_alias_url',
    :s3_host_name => ENV['S3_HOST_NAME'],
    :s3_host_alias => ENV['S3_HOST_ALIAS'],
    :path => '/:class/:attachment/:id_partition/:style/:filename',
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :s3_region => 'ap-southeast-2'
    }
  }

  config.active_storage.service = :local
  config.action_mailer.perform_caching = false
  # config.default_url_options[:host] = 'localhost'
  # default_url_options :host => 'localhost'

  # use mailcatcher to catch all emails in development environemnt
  # http://mailcatcher.me/
  # run following command
  # -
  # gem install mailcatcher
  # mailcatcher
  # -

  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
      address: 'localhost', port: 1025
  }

  config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"

  Rails.application.config.middleware.use ExceptionNotification::Rack,
  email: {
    # deliver_with: :deliver, # Rails >= 4.2.1 do not need this option since it defaults to :deliver_now
    email_prefix: '[PREFIX] ',
    sender_address: %{"notifier" <notifier@example.com>},
    exception_recipients: %w{sharma.deepti369@gmail.com}
  }
  config.action_mailer.delivery_method = :letter_opener
  #Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
