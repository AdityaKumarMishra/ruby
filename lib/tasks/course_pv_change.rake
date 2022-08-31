namespace :course_pv_change do
  task course_product_version_change: :environment do
    Course.where(product_version_id: [72, 73, 74, 75]).each do |course|
      course.paid_enrolments.each do |enrolment|
        course.product_version.product_version_feature_prices.where(is_additional: false).each do |pf|
          acquired = pf.is_default ? DateTime.now : nil
          fe = pf.feature_logs.find_by(enrolment_id: enrolment.id, qty: pf.qty)
          fe = pf.feature_logs.create(acquired: acquired, enrolment_id: enrolment.id, qty: pf.qty) unless fe.present?
          fe.assign_hours_if_pv_changed if pf.master_feature.private_tutoring? && pf.is_default
        end
      end
    end
  end
end
