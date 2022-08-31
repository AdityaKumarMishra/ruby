Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.require_master_key = true
  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true
  
  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  ## old configuration
  # config.paperclip_defaults = {
  #   :storage => :s3,
  #   :s3_protocol => 'http',
  #   :bucket => ENV['S3_BUCKET_NAME'],
  #   :s3_host_name => ENV['S3_HOST_NAME'],

  #   :s3_credentials => {
  #     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  #     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  #   }
  # }

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_protocol => 'https',
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
  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = true

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.middleware.insert_before ActionDispatch::SSL, Rack::HostRedirect, {
    'www.gradready.com.au' => 'gradready.com.au'
  }

  config.force_ssl = true

  # Disable HSTS until we are certain that HTTPS is configured correctly.
  config.ssl_options = { hsts: false }

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true
  config.active_elastic_job.aws_region = 'ap-southeast-2'
  config.action_mailer.perform_deliveries = true

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).

  # config.time_zone = 'Australia/Melbourne'

  # Startup whenever
  # config.after_initialize do
  #   raise 'whenever task scheduler failed to start' unless system('whenever --update-crontab')
  # end

  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  ### added on upgrading to rails 5 <start>#####
  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local
  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "gradready_#{Rails.env}"
  config.action_mailer.perform_caching = false
  config.action_mailer.deliver_later_queue_name = ENV['QUEUE_NAME']
  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  ###added on upgrading to rails 5 <end>#####

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV['MAIL_PROVIDER_ADDRESS'],
    port: ENV['MAIL_PROVIDER_PORT'],
    domain: ENV['MAIL_PROVIDER_DOMAIN'],
    user_name: ENV['MAILER_USERNAME'],
    password: ENV['MAILER_PASSWORD'],
    authentication: ENV['MAIL_PROVIDER_AUTH_TYPE'],
    enable_starttls_auto: true

  }
Rails.application.config.middleware.use ExceptionNotification::Rack,
  email: {
    email_prefix: '[PREFIX] ',
    sender_address: %{"notifier" <notifier@example.com>},
    exception_recipients: %w{sharma.deepti369@gmail.com lakhan.meena@ongraph.ca}
  }
end


