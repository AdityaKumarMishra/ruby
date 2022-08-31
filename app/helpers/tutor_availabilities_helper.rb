module TutorAvailabilitiesHelper
  def access_private_booking?(user)
    view_private_booking?(user) || create_private_booking?(user) ? true : false
  end

  def view_private_booking?(user)
    user.admin? || user.superadmin? ? true : false
  end

  def create_private_booking?(user)
    user.tutor_profile && user.tutor_profile.private_tutor ? true : false
  end
end
