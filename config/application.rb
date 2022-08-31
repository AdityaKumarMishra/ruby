require_relative 'boot'
require 'rails'
require 'zip'
require 'csv'
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
require 'openssl'
Bundler.require(*Rails.groups)
# Raven.configure do |config|
#   config.dsn = ENV['SENTRY_DSN']
#   config.server = ENV['SENTRY_DSN']
#   config.ssl_verification = false
#   config.environments = ['development', 'production', 'test']
#   config.excluded_exceptions = []
#   #config.async = lambda { |event| SentryJob.perform_later(event) }
# end

WillPaginate.per_page = 10

module Gradready
  class Application < Rails::Application
    config.load_defaults 6.0
    # config.middleware.use Rack::Deflater
    # Use the responders controller from the responders gem
    # config.app_generators.scaffold_controller :responders_controller
    config.enable_dependency_loading = true
    config.action_controller.per_form_csrf_tokens = true
    config.action_controller.forgery_protection_origin_check = true
    config.assets.precompile += %w( public_pages/banner.css)
    config.assets.precompile += %w( ckeditor/* )
    config.assets.precompile += %w( public_page.js )
    config.assets.precompile += %w( public_page.css )

    if Rails.env.development? || Rails.env.test? || Rails.env.stage? || ENV['ACTIVEJOB_QUEUE'].nil?
      # Unless on stage or production, use inline to test activejobs
      #config.active_job.queue_adapter = :inline
    else
      config.active_elastic_job.aws_region = 'ap-southeast-2'
      config.active_job.queue_adapter = :active_elastic_job
      config.active_job.queue_name_prefix = ENV['ACTIVEJOB_QUEUE']
    end

    config.autoload_paths += %W(#{config.root}/app/models/products
                                #{config.root}/app/models/product_type
                                #{config.root}/app/models/marks
                                #{config.root}/app/models/purchases
                                #{config.root}/app/models/australian_post
                                #{config.root}/app/models/exams
                                #{config.root}/app/models/features
                                #{config.root}/app/models/job_applications
                                #{config.root}/lib/features)
    ## changed for rails 6 autoloads path can't have wildcards
    #config.autoload_paths += Dir["#{config.root}/lib/features/**"]
    config.autoload_paths += Dir["#{config.root}/lib/features/**/*"]

    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'javascripts')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Australia/Melbourne'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    #config.i18n.default_locale = :en
    # force SSL
    #config.force_ssl = true

    # Do not swallow errors in after_commit/after_rollback callbacks.
    #config.active_record.raise_in_transactional_callbacks = true
    config.currency_dictionary = %w(aud gbp eur usd)
    config.exceptions_app = self.routes

    config.to_prepare do
      DeviseController.respond_to :html, :json
    end

    # AWS Healthcheck needs to run early in the middleware chain to prevent Canonical URLs
    # or forcing SSL to interfere with AWS healthcheck returning a 200
    if Rails.env.stage? || Rails.env.production?
      config.middleware.delete Healthcheck::Middleware
      config.middleware.insert_before ActionDispatch::SSL, Healthcheck::Middleware
    end

    config.middleware.insert_before 0, Rack::Rewrite do
      r301 '/gamsat-preparation-courses/success-assured/', '/gamsat-preparation-courses/success-assured'
      r301 '/gamsat-preparation-courses/online-essentials/', '/gamsat-preparation-courses/online-essentials'
      r301 '/gamsat-preparation-courses/online-comprehensive/', '/gamsat-preparation-courses/online-comprehensive'
      r301 '/gamsat-preparation-courses/attendance-comprehensive/', '/gamsat-preparation-courses/attendance-comprehensive'
      r301 '/gamsat-preparation-courses/attendance-essentials/', '/gamsat-preparation-courses/attendance-essentials'
      r301 '/gamsat-preparation-courses/attendance-complete-care/', '/gamsat-preparation-courses/attendance-complete-care'
      r301 '/gamsat-preparation-courses/custom/', '/gamsat-preparation-courses/custom'
      r301 '/gamsat-preparation-courses/interview-attendance-comprehensive/', '/gamsat-preparation-courses/interview-attendance-comprehensive'


      r301 '/gamsat-preparation-courses/interview-online-essentials/', '/gamsat-preparation-courses/interview-online-essentials'
      r301 '/gamsat-preparation-courses/interview-attendance-essentials/', '/gamsat-preparation-courses/interview-attendance-essentials'

      r301 '/gamsat-preparation-courses/free-trial/', '/gamsat-preparation-courses/free-trial'

      r301 '/blog/gamsat', '/blog/gamsat-preparation-courses'
      r301 %r{/gamsat/(.*)}, '/gamsat-preparation-courses/$1'
      r301 %r{/umat/(.*)}, '/umat-preparation-courses/$1'
      r301 %r{/job_application_forms/(.*)}, '/jobs/$1'
      r301 %r{/job_applications/(.*)}, '/job-applications/$1'

      # r301 %r{/umat-preparation-courses/(.*)}, '/umat-preparation-courses'

      r301 '/blog/umat-preparation-courses', '/umat-preparation-courses'

      r301 '/hsc', '/'
      r301 '//hsc', '/'
      r301 %r{/hsc/(.*)}, '/'
      r301 '/blog/hsc', '/'
      r301 '//blog/hsc', '/'
      r301 %r{/posts/hsc-preparation-courses/(.*)}, '/'


      r301 '/vce', '/'
      r301 '//vce', '/'
      r301 %r{/vce/(.*)}, '/'
      r301 '/blog/vce', '/'
      r301 '//blog/vce', '/'
      r301 %r{/posts/vce-preparation-courses/(.*)}, '/'

      r301 '/gamsat-preparation-courses/blog/55b0df463f2a81b31800036c', '/posts/gamsat-preparation-courses/chat-with-medical-students-at-free-bbq'
      r301 '/umat-preparation-courses/UMATReady', '/umat-preparation-courses'
      r301 '/umat-preparation-courses/compare_umatready', '/umat-preparation-courses'
      r301 '/interviewready/interviewready', '/gamsat-preparation-courses/interview-attendance-comprehensive'

      r301 '/umat-preparation-courses/online-essentials/', '/umat-preparation-courses/online-essentials'
      r301 '/umat-preparation-courses/online-comprehensive/', '/umat-preparation-courses/online-comprehensive'
      r301 '/umat-preparation-courses/attendance-comprehensive/', '/umat-preparation-courses/attendance-comprehensive'
      r301 '/umat-preparation-courses/attendance-essentials/', '/umat-preparation-courses/attendance-essentials'
      r301 '/umat-preparation-courses/attendance-complete-care/', '/umat-preparation-courses/attendance-complete-care'
      r301 '/umat-preparation-courses/custom/', '/umat-preparation-courses/custom'
      r301 '/umat-preparation-courses/free-trial/', '/umat-preparation-courses/free-trial'
      r301 '/blog/umat', '/blog/umat-preparation-courses'

      r301 '/jobs/available_positions', '/jobs/available-positions'
      r301 '/job_application_forms', '/jobs'

      r301 '/confirmation/new', '/confirmation'

      r301 '/gamsat-preparation-courses/compare', '/gamsat-preparation-courses#comparison_table'
      r301 '/blog/umat-preparation-courses/', '/blog/umat-preparation-courses'
      r301 '/blog/gamsat-preparation-courses/', '/blog/gamsat-preparation-courses'
      r301 '/blog/wp-includes/wlwmanifest.xml', '/blog'
      r301 '/gamsat-2018', '/gamsat-2022'
      r301 '/gamsat-2019', '/gamsat-2022'
      r301 '/gamsat-2020', '/gamsat-2022'
      r301 '/gamsat-2021', '/gamsat-2022'
      r301 '/gamsat-preparation-courses/free_resources', '/free-gamsat-preparation-materials'
      r301 '/gamsat-free', '/free-gamsat-preparation-materials'
    end

    # Some particularly expensive queries require caching to improve performance
    config.cache_store = :memory_store, { size: 128.megabytes }

    config.middleware.use Rack::TempfileReaper
    
    ActiveRecord::SessionStore::Session.table_name = 'sessions'
    ActiveRecord::SessionStore::Session.primary_key = 'session_id'
    ActiveRecord::SessionStore::Session.data_column_name = 'data'
    ActiveRecord::SessionStore::Session.serializer = :json
  end
end
