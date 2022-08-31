namespace :change_feature_log do
  task accuired_change_for_feature_logs: :environment do
    User.all.each do |user|
      user.purchase_items.all.select{|p| p.purchasable_type == "FeatureLog" && p.order.status == "paid" && p.purchasable.acquired.nil?}.each do |pi|
        pi.purchasable.update_attribute(:acquired, pi.created_at)
      end
    end
  end

  task update_online_exams_feature_logs_qty_six_to_eight: :environment do
    User.all.each do |user|
      unless user.courses.blank?
        ((user.feature_logs.includes(:product_version_feature_price).where(product_version_feature_prices: { product_version_id: user.courses.pluck(:product_version_id) })).includes(enrolment: :course).where("acquired IS NOT NULL AND (enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND courses.expiry_date >= ? AND courses.id IN (?)", false, true, Time.zone.now, Time.zone.today.beginning_of_day, user.courses.pluck(:id)).references(:course)).includes(:master_feature).where('master_features.name LIKE ? AND master_features.name NOT LIKE ?', '%ExamFeature%', '%Live%').where(qty: 6, description: nil).group_by(&:enrolment_id).values.each do |fea_lo_arr|
            fea_lo_arr.last.increment!(:qty, 2)
          end
      end
    end
  end

  task update_online_exams_feature_logs_qty_by_one: :environment do
    User.all.each do |user|
      unless user.courses.blank?
        ((user.feature_logs.includes(:product_version_feature_price).where(product_version_feature_prices: { product_version_id: user.courses.pluck(:product_version_id) })).includes(enrolment: :course).where("acquired IS NOT NULL AND (enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND courses.expiry_date >= ? AND courses.id IN (?)", false, true, Time.zone.now, Time.zone.today.beginning_of_day, user.courses.pluck(:id)).references(:course)).includes(:master_feature).where('master_features.name LIKE ? AND master_features.name NOT LIKE ?', '%ExamFeature%', '%Live%').group_by(&:enrolment_id).values.each do |fea_lo_arr|
            fea_lo_arr.last.increment!(:qty, 1)
          end
      end
    end
  end

  task update_existing_private_tutoring_qty: :environment do
    flid = FeatureLog.includes(:master_feature).where('master_features.name LIKE (?) AND feature_logs.qty < 0', '%PrivateTutoringFeature%').references(:master_features).map(&:id)
    FeatureLog.where(id: flid).each do |fl|
      fl.update_attribute(:qty, 7)
    end
  end
end
