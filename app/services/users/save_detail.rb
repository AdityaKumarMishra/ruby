module Users
  class SaveDetail
    attr_accessor :user, :user_params, :current_course, :controller, :params

    def initialize(user, user_params, current_course, controller, params)
      @user = user
      @user_params = user_params
      @current_course = current_course
      @controller = controller
      @params = params
    end

    class << self
      def call(user, user_params, current_course, controller, params)
        new(user, user_params, current_course, controller, params).call
      end
    end

    def call
      path = if user_params[:questionnaire_attributes].present?
              controller.dashboard_home_path
            else
              controller.course_details_user_path(user)
            end
      order = user.orders.includes(:purchase_items).where('purchase_items.purchase_description LIKE ? ', '%Custom course for Free trail%').references(:purchase_items).first
      if order.present? && current_course.present? && ProductVersion.course_types[current_course.product_version.course_type] == 0 && order.present? && !params[:update_questionnaire].present?
        enrolment = user.enrolments.includes(:order).find_by(orders: { id: order.try(:id) })
        custom_course = enrolment.try(:course)
        if user.address.present?
          course = Course.where(product_version_id: custom_course.product_version_id, city: Course::CITIES[user.state.to_sym]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order('id desc').select{|p| !p.enrolments_full?}.first
        else
          course = Course.where(product_version_id: custom_course.product_version_id).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order('id desc').select{|p| !p.enrolments_full?}.first
        end
        order.update_attribute(:course_id, course.try(:id))
        order.update_course_detail
      end

      if user.active_course.present? && user.active_course.customable?
        path = controller.dashboard_home_path
      else
        path = user.validate_order_presence ? controller.order_path(user.validate_order, payment_page: true) : controller.order_path(-1, placeholder: true)
      end

      path
    end
  end
end
