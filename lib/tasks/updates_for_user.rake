namespace :updates_for_user do
  task update_essay_transferred: :environment do

    staffs = StaffProfile.where('id IN (SELECT DISTINCT(staff_profile_id) FROM essay_tutor_responses)').map{|s| s.staff}
    staffs.each do |s|
      s.update_attribute(:essay_transferred, false)
    end

    tutors = EssayResponse.all.map{|a| a.tutor}.uniq
    tutors.each do |s|
      s.update_attribute(:essay_transferred, false)
    end
  end
end

