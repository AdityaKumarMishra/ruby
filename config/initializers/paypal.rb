PayPal::SDK.load("config/paypal.yml", Rails.env)
PayPal::SDK.logger = Rails.logger
PayPal::SDK.logger.level = Logger::DEBUG if Rails.env.development?