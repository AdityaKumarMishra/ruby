module Users
  class StudyGuide
    attr_accessor :params, :user_params, :user, :controller

    def initialize(params, user_params, user, controller)
      @params = params
      @user_params = user_params
      @user = user
      @controller = controller
    end

    class << self
      def call(params, user_params, user, controller)
        new(params, user_params, user, controller).call
      end
    end

    def call
      product_version = if params[:commit] == 'Gamsat'
                          ProductVersion.find_by(course_type: 10, type: 'GamsatReady')
                        else
                          ProductVersion.find_by(course_type: 10, type: 'UmatReady')
                        end
      if product_version.present?
        course = product_version.courses.where(city: Course.cities['Other']).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order('id DESC').select{|p| !p.enrolments_full?}.first
        unless course.present?
          course = product_version.courses.where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order('id DESC').select{|p| !p.enrolments_full?}.first
        end
      end
      error = nil
      user = User.new(user_params)
      if course.present? && user.save
        controller.sign_in(user)
        path = controller.course_enrolments_enrol_path(course_id: course.id)
      elsif !(user.save)
        user = User.find_by(email: params[:user][:email])
        if user.present?
          sign_in(user)
          error = 'Thanks for signing up for our Free Study Guide! You already have access to it with your enrolment, you can find it under the Written Resources (Supplementary Resources) tab'
          path = controller.dashboard_home_path
        else
          error = 'Error in enrolling in Free Study Guide'
          path = controller.root_path
        end
      else
        error = 'Error in enrolling in Free Study Guide'
        path = controller.root_path
      end

      [error, user, course, path]
    end
  end
end
