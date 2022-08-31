Rails.configuration.stripe = {
  :publishable_key => 'pk_test_hFjcBKUag8caCnSgcoBDCZGo',
  :secret_key      => 'sk_test_vcWqubo4MlSBDDQzEvvIvLvI'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
