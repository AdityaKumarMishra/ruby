class ActivatePastPurchaseAddons < ActiveRecord::Migration[6.1]
  # Migration activates all feature enrolments that were meant to have been bought via the old purchase addons method but were not actually activated
  #lots of if statements to deal with dodgy data
  def up
    PurchaseAddon.all.each do |pa|
      next if pa.enrolment.nil?
      user = pa.enrolment.user
      next if user.nil?
      JSON.parse(PurchaseAddon.last.features).keys.each do |feature_id|
        feature = Feature.find_by_id(feature_id)
        next if feature.nil?
        feature_enrolment = FeatureEnrolment.includes(:feature, :enrolment).where("feature_id = ? and enrolment_id = ?", feature.id, pa.enrolment.id).first
        next if feature_enrolment.nil?
        if feature_enrolment.featurettes.empty?
          featurette = Featurette.create(feature_enrolment_id: feature_enrolment.id, initial_cost: feature.price, options: feature_enrolment.options, description: feature.name)
        else
          featurette = feature_enrolment.featurettes.first
        end
        order = Order.create(user: user, status: :paid, purchase_method: :paypal, paid_at: (pa.date_activated || Time.now))
        if featurette.purchase_item.nil?
          purchase_item = PurchaseItem.create(initial_cost: featurette.initial_cost, method_fee: pa.paypal_fee, added_gst: (featurette.initial_cost + pa.paypal_fee)*0.1, purchase_description: featurette.description,
          purchasable_type: featurette.class.name, purchasable_id: featurette.id, order: order, user: user)
        else
          purchase_item = featurette.purchase_item
          purchase_item.update(method_fee: pa.paypal_fee, added_gst: (featurette.initial_cost + pa.paypal_fee)*0.1, order: order)
        end
        feature_enrolment.update(active: true)
      end
    end
  end

  def down
  end
end
