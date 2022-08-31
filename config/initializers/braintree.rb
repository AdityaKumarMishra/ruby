if Rails.env.production?
  Braintree::Configuration.environment =  :production # if Rails.env.production?
  Braintree::Configuration.merchant_id = ENV['BRAINTREE_MERCHANT_ID']
  Braintree::Configuration.public_key = ENV['BRAINTREE_PUBLIC_KEY']
  Braintree::Configuration.private_key = ENV['BRAINTREE_PRIVATE_KEY']

else
  Braintree::Configuration.environment =  :sandbox # if Rails.env.production?
  Braintree::Configuration.merchant_id = "rvvpxjsz6t6rmbnb"
  Braintree::Configuration.public_key = "y6fb2kmf3r5x3gpv"
  Braintree::Configuration.private_key = "cfcd88edac9930516d274bf06ae290c9"
end