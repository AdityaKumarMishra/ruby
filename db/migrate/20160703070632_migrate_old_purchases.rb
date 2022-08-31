class MigrateOldPurchases < ActiveRecord::Migration[6.1]
  def change
    Enrolment.all.each do |en|
      next if en.purchase_item.present?
      if en.paypal_fee.present? && en.paypal_fee>0
        temp_order = Order.create(user: en.user, status: "paid", brain_tree_reference: en.paypal_token,  paid_at: en.paid_at, purchase_method: "paypal")
        purchase_item = PurchaseItem.create(initial_cost:en.subtotal, added_gst: en.gst, method_fee: en.paypal_fee, purchasable_id: en.id, purchasable_type: en.class.name,
                                            discount_applied: 0.0, order: temp_order, user: en.user,
                                            purchase_description: en.course.product_version.name + " " + en.course.product_version.type)
      else
        temp_order = Order.create(user: en.user, status: "paid", brain_tree_reference: en.paypal_token,  paid_at: en.paid_at, purchase_method: "direct_deposit")
        purchase_item = PurchaseItem.create(initial_cost:en.subtotal, added_gst: en.gst, method_fee: en.paypal_fee, purchasable_id: en.id, purchasable_type: en.class.name,
                                            discount_applied: 0.0, order: temp_order, user: en.user,
                                            purchase_description: en.course.product_version.name + " " + en.course.product_version.type)
      end
      if purchase_item.initial_cost.nil?
        purchase_item.update(initial_cost: en.course.product_version.price, added_gst: en.course.product_version.price*0.1)
      end
    end
  end
end
