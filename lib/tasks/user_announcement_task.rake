namespace :user_announcement_task do
  task create_user_announcements: :environment do
    unless UserAnnouncement.count > 0
      Announcement.all.each do |announcement|
        User.student.each do |student|
          announcement.user_announcements.create(user_id: student.id, viewed: true)
        end
      end
    end
    a = Announcement.find_by(name: 'Diagnostic Assessment')
    a.update_attribute(:name, 'Diagnostics Assessment') if a.present?
  end
end

