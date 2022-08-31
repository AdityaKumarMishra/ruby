json.array!(@purchase_addons) do |purchase_addon|
  json.extract! purchase_addon, :id, :paid_at, :date_activated, :date_deactivated, :features, :subtotal, :gst, :paypal_fee, :paypal_payment, :paypal_token, :banktrans, :paypal, :bank
  json.url purchase_addon_url(purchase_addon, format: :json)
end
