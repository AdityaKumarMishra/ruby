namespace :orders do
  task add_user_to_feature_logs: :environment do
    successful_orders = []
    failed_orders = []

    PurchaseItem.where(purchasable_type: 'FeatureLog').includes(purchasable: :enrolment).find_each do |purchase_item|
      purchase_item.purchasable.enrolment.update!(order: purchase_item.order)

      successful_orders.push(purchase_item.order.id)
    rescue StandardError => e
      failed_orders.push(purchase_item.order.id)
    end

    Rails.logger.info "Successful orders: #{successful_orders.join(', ')}"
    Rails.logger.info "Failed orders: #{failed_orders.join(', ')}"
  end
end
