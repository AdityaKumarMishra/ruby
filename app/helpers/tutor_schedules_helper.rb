module TutorSchedulesHelper

  def booking_allow_option
    [7,6,5,4,3,2].map { |n| [n,n]}
  end
end
