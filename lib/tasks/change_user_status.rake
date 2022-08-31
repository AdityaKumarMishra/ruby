namespace :change_user_status do
  task change_user_status: :environment do
    User.pending.each do |user|
      next unless user.courses.present?
      course_expiry = user.courses.pluck(:expiry_date).compact.max
      if course_expiry.present? && course_expiry > Date.today
        user.update_attribute(:status, User.statuses['activated'])
      else
        user.update_attribute(:status, User.statuses['deactivated'])
      end
    end
  end

  task prepare_user_statuses_for_pending_removal: :environment do
    User.where.not(status: 2).update_all(status: 0)
    User.where(status: 2).update_all(status: 1)
  end
end
