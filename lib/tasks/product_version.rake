namespace :product_version do
  task :update_features => :environment do
    ProductVersion.all.each do |pv|
      pv.update_features!
    end
  end
  task destroy_corrupt_product: :environment do
    ProductVersionFeaturePrice.where(master_feature_id: nil).each {|p| p.destroy}
  end

  task update_freemium: :environment do
    ProductVersion.where(course_type: 'free_trial').update_all(freemium: true)
  end

  desc 'associate existing ProductVersions with product line'
  task associate_with_product_lines: :environment do
    ProductLine.all.each do |product_line|
      ProductVersion.where(product_line_id: nil).where('type ilike ?', "#{product_line.name}%").update_all(product_line_id: product_line.id)
    end
  end

  desc 'remove duplicate product version feature prices'
  task remove_duplicate_pvfp: :environment do
    ProductVersionFeaturePrice.where(is_default: true, is_additional: true).each do |dodgy|
      correct = ProductVersionFeaturePrice.where(product_version_id: dodgy.product_version_id, master_feature_id: dodgy.master_feature_id,
                                                 is_default: true, is_additional: false).first
      if correct.present?
        migrate_duplicate(correct.id, dodgy.id)
      end
    end
  end

  desc 'associate product version feature prices subtype'
  task associate_product_version_feature_prices: :environment do
    ProductVersionFeaturePrice.includes(:master_feature).find_each do |pvfp|
      master_feature = pvfp.master_feature

      if master_feature.private_tutoring? || master_feature.essay? || master_feature.exam_feature?
        pvfp.update!(subtype: :subtype_1)
      else
        pvfp.update!(subtype: :subtype_2)
      end
    end
  end

  desc 'update exam feature_qty_from 6 to 8 for stage only'
  task update_exam_feature_qty_frm_six_to_eight: :environment do
    ProductVersion.includes(:product_line).where(product_lines:{name: "gamsat"}).each do |pv|
      pv.product_version_feature_prices.includes(:master_feature).where('master_features.name LIKE ? AND master_features.name NOT LIKE ?', '%ExamFeature%', '%Live%').references(:master_features).where(qty: 6).each do |pvfp|
        pvfp.update_attribute(:qty, 8)
      end
    end
  end

  desc 'update exam feature_qty_from 8 to 9 for prod and stage'
  task update_exam_feature_qty_frm_eight_to_nine: :environment do
    ProductVersion.includes(:product_line).where(product_lines:{name: "gamsat"}).each do |pv|
      pv.product_version_feature_prices.includes(:master_feature).where('master_features.name LIKE ? AND master_features.name NOT LIKE ?', '%ExamFeature%', '%Live%').references(:master_features).where(qty: 8).each do |pv|
        pv.update_attribute(:qty, 9)
      end
    end
  end



  def migrate_duplicate(id_remain, id_delete)
    pvfp_delete = ProductVersionFeaturePrice.find_by_id(id_delete)
    pvfp_delete.feature_logs.update_all(product_version_feature_price_id: id_remain)
    pvfp_delete.destroy
  end
end
