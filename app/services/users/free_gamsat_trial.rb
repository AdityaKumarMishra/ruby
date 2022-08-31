module Users
  class FreeGamsatTrial
    attr_accessor :params, :user_params, :session, :controller

    def initialize(params, user_params, session, controller)
      @params = params
      @user_params = user_params
      @session = session
      @controller = controller
    end

    class << self
      def call(params, user_params, session, controller)
        new(params, user_params, session, controller).call
      end
    end

    def call
      product_version = ProductVersion.find_by(course_type: 0, slug: "free-gamsat-trial")
      if product_version.present?
        course = product_version.courses.where(city: Course.cities['Other']).where('enrolment_end_date >= ? AND link_with_homepage_ft = ?', Time.zone.now.beginning_of_day, true).order('id DESC').select{|p| !p.enrolments_full?}.first
        unless course.present?
          course = product_version.courses.where('enrolment_end_date >= ? AND link_with_homepage_ft = ?', Time.zone.now.beginning_of_day, true).order('id DESC').select{|p| !p.enrolments_full?}.first
        end
      end
      user = User.new(user_params)
      notice = nil
      error = nil
      if course.present? && user.save && controller.verify_recaptcha(model: user)
        session[:registration_count] += 1
        controller.sign_in(user)
        path = controller.course_enrolments_enrol_path(course_id: course.id)
      elsif !(user.save)
        user = User.find_by(email: params[:user][:email])
        if user.present?
          controller.sign_in(user)
          if user.courses.blank? && user.enrolments.blank?
            user.send_confirmation_instructions if user.confirmed_at.blank?
            notice = 'Thanks for signing up for our Free Gamsat Trial'
            path = controller.course_enrolments_enrol_path(course_id: course.id)
          else
            error = 'Thanks for signing up for our Free Gamsat Trial'
            path = controller.dashboard_home_path
          end
        else
          error = 'Error in enrolling in Free Gamsat Trial'
          if user_params[:redirect_sign_up].present?
            path = controller.new_user_session_path
          else
            path = controller.root_path
          end
        end
      else
        error = 'Error in enrolling in Free Gamsat Trial'
        if user_params[:redirect_sign_up].present?
          path = controller.new_user_session_path
        else
          path = controller.root_path
        end
      end

      [course, user, error, notice, path]
    end
  end
end
