namespace :purchase_addons do
  task chnage_featurette_purchase_item: :environment do
    purchase_items = PurchaseItem.where(purchasable_type: 'Featurette')
    if purchase_items.present?
      purchase_items.each do |item|
        ft = featurette = item.purchasable
        fe = feature_enrolment = featurette.feature_enrolment
        feature = feature_enrolment.try(:feature)
        master_feature = MasterFeature.find_by(name: feature.name) if feature
        if master_feature.present?
          pvfp = item.user.product_version_feature_prices.find_by(master_feature_id: master_feature.id)
          qty = feature.essay_num ? feature.essay_num : feature.tutor_time
          if pvfp.present?
            feature_log = item.user.feature_logs.where(product_version_feature_price_id: pvfp.id).where.not(acquired: nil).first
            if feature_log.present?
              feature_log.update(qty: qty)
            else
              feature_log = item.user.feature_logs.find_by(product_version_feature_price_id: pvfp.id)
              if fe.active
                acquired = fe.created_at
                suspended = nil
              else
                acquired = nil
                suspended = fe.created_at
              end
              feature_log.update(acquired: acquired, qty: qty, suspended: suspended)
            end
            item.purchasable_type = 'FeatureLog'
            item.purchasable_id = feature_log.id
            item.save
          else
            pvfp = ProductVersionFeaturePrice.find_or_create_by(product_version_id:
                                                     feature.product_version_id,
                                                                master_feature_id:
                                                     master_feature.id,
                                                                price: feature.price,
                                                                qty: qty,
                                                                is_default: feature.is_default
                                                               )
            feature.taggings.each do |tagging|
              tagging.update(taggable_id: pvfp.id,
                                        taggable_type: 'ProductVersionFeaturePrice'
                                       )
            end

            if fe.active
              acquired = fe.created_at
              suspended = nil
            else
              acquired = nil
              suspended = fe.created_at
            end

            options = JSON.parse ft.options
            qty = Feature.fetch_quantity(options)
            fl = FeatureLog.create(acquired: acquired, suspended: suspended,
                                   description: ft.description, qty: qty,
                                   product_version_feature_price: pvfp,
                                   enrolment_id: fe.enrolment_id
                                  )

            item.purchasable_type = 'FeatureLog'
            item.purchasable_id = fl.id
            item.save
          end
        else
          order = item.order
          order.status = 0
          order.save!
        end
      end
    end
  end
end
