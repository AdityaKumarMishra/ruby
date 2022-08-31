json.discount_info do
  json.initial_cost @order.total_initial_cost
  json.added_gst @order.total_added_gst
  json.method_fee @order.total_method_fee || 0
  json.discount_applied @order.total_discount
end
json.total_cost @order.total_cost
