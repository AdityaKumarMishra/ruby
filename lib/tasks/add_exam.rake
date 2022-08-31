namespace :enrolments do
  task :add_exam ,[:qty, :pv_id] => :environment do |t, args|
    product_version = ProductVersion.find_by(slug: args.pv_id)
    master_feature = MasterFeature.type(product_version.type).find_by(name: "GamsatExamFeature")
    if args.qty == "nil"
      qty = ProductVersionFeaturePrice.find_by(product_version_id: product_version.id, master_feature_id: master_feature.id, is_additional: false).qty
    else
      qty = args.qty.to_i
    end 
    if qty <= 20
      product_version_feature_logs = FeatureLog.includes(:product_version_feature_price).where(product_version_feature_prices: { product_version_id: product_version.id, master_feature_id: master_feature.id })
      all_feature_logs = product_version_feature_logs.includes(enrolment: :course).where("(enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND courses.expiry_date >= ?", false, true, Time.zone.now, Time.zone.today.beginning_of_day).references(:course)
      all_feature_logs.update_all(qty: qty)
    end
  end
end
