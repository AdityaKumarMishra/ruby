namespace :create_free_study_guide do
  task create_free_study_guide_pv: :environment do
    pv = ProductVersion.find_or_create_by(name: "Free Study Guide",
                            type: "GamsatReady", price: 0,
                            description: "Free Study Guid",
                            product_line_id: 1,
                            course_type: 10
                            )
    custom_pv = ProductVersion.find(45)
    custom_pv.product_version_feature_prices.where(is_additional: false).each do |pvfp|
      pvfp_new = pv.product_version_feature_prices.create(master_feature_id: pvfp.master_feature_id,
        price: pvfp.price, qty: pvfp.qty, is_default: pvfp.is_default,
        is_additional: false
        )
      pvfp_new.taggings.create(tag_id: pvfp.tags.first.id)
    end
  end
end
