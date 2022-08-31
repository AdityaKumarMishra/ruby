class MigrateOldTransfers < ActiveRecord::Migration[6.1]
  def change
    TransferTransaction.where(paid: false).each do |t|
      order = Order.create(user: t.user, reference_number: t.banking_reference, status: "pending", purchase_method: "direct_deposit_classic")
      enrolment = Enrolment.create(course_id: t.course_id, subtotal: t.course.price, gst: t.course.tax, banktrans: t.banking_reference)
      purchase_item = PurchaseItem.create(user: t.user, order: order, initial_cost: t.course.price, added_gst: t.course.tax, purchasable_id: enrolment.id, purchasable_type: enrolment.class.name,
      discount_applied: 0.0, purchase_description: enrolment.course.product_version.name + " " + enrolment.course.product_version.type)
    end
  end
end
