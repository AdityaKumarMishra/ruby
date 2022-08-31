namespace :destroy_ongoing_featurettes do
  desc 'Go through and destroy all purchase items associated with an ongoing order'
  task destroy_purchase_items: :environment do
    PurchaseItem.clear_cart
  end
end
