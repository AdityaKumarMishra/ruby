class ConfirmFeatureEnrolmentPurchased < ActiveRecord::Migration[6.1]
  # There was a small bug where a couple users purchased features that weren't given to them, this ensures they get the features
  def up
    Featurette.all.select {|feat| feat.purchase_item.present? && feat.purchase_item.order.present? && feat.purchase_item.order.paid?}.each do |featurette|
      featurette.feature_enrolment.update(active: true)
  end

  def down
  end

  end
end
