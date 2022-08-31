Recaptcha.configure do |config|
  config.skip_verify_env.push("development")
  config.site_key = Rails.application.secrets[:recaptcha_public_key]
  config.secret_key = Rails.application.secrets[:recaptcha_private_key]
end