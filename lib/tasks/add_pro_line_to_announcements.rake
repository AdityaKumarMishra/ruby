namespace :add_pro_line_to_announcements do
  task add_line_to_dashboard_announcement: :environment do
    gamsat_announcement = Announcement.where("name like ? AND category IN (?)", "%Gamsat%", ["Dashboardpage", "Homepage"])
    gamsat_announcement.update_all(product_line_id: 1) if gamsat_announcement.present?

    umat_announcement = Announcement.where("name like ? AND category IN (?)", "%Umat%", ["Dashboardpage", "Homepage"])
    umat_announcement.update_all(product_line_id: 2) if umat_announcement.present?

  end
end
