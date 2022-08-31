namespace :add_qty_for_free_trial do
  desc "Add qty for Free trail course"
  task add_qty_for_free_trial: :environment do
    pvs = ProductVersion.where(course_type: 0)
    pvs.each do |pv|
      pv.product_version_feature_prices.each do |pvfp|
        if pvfp.access_limit.present?
          pvfp.feature_logs.update_all(qty: pvfp.access_limit)
        end
      end
    end
  end
end
