module Users
  class UpdateCourseOrderDetail
    attr_accessor :params, :course, :current_user, :enrolment, :order

    def initialize(params, course, current_user, enrolment, order)
      @params = params
      @course = course
      @current_user = current_user
      @enrolment = enrolment
      @order = order
    end

    class << self
      def call(params, course, current_user, enrolment, order)
        new(params, course, current_user, enrolment, order).call
      end
    end

    def call
      show_lesson = true
      custom_mock = nil
      if enrolment.feature_logs.where(description: 'custom purchase').present?
        custom_enrollment_new_user = enrolment.feature_logs.where(description: 'custom purchase').last
        enrolment.purchase_item.update(shipping_cost: current_user.textbook_shipping_cost) if custom_enrollment_new_user.product_version_feature_price.present? && custom_enrollment_new_user.product_version_feature_price.master_feature.present? &&  custom_enrollment_new_user.product_version_feature_price.master_feature.hardcopy?

        if enrolment.feature_logs.where(description: 'custom purchase').includes(:master_feature).where('master_features.name LIKE?', '%LiveExam%').references(:master_features).present?
          custom_mock = true
        else
          show_lesson = false
        end
      end
      if !params[:different_course].present? && [4,5, 11].include?(ProductVersion.course_types[@course.product_version.course_type]) && current_user.state.present?
        @course = Course.where(product_version_id: course.product_version_id, city: Course::CITIES[current_user.state.to_sym]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order('id DESC').select{|p| !p.enrolments_full?}.first
        @course = enrolment.try(:course) if @course.nil?
        order.update_attribute(:course_id, @course.try(:id))
      end
      if !params[:different_course].present? &&  !params[:reselect_course].present? && [1].include?(ProductVersion.course_types[course.product_version.course_type]) && current_user.state.present?
        if ProductVersion.course_types[course.product_version.course_type] == 1 && custom_mock.present?
          @course = @course
        else
          @course = Course.where(product_version_id: course.product_version_id, city: Course::CITIES[current_user.state.to_sym]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order('id DESC').select{|p| !p.enrolments_full?}.first
          @course = enrolment.try(:course) if @course.nil?
        end
        order.update_attribute(:course_id, @course.try(:id))
      end

      cities = Course.where(product_version_id: @course.try(:product_version_id)).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).select{|p| !p.enrolments_full?}.collect(&:city).uniq.compact.sort
      if custom_mock
        courses = Course.includes(:lessons).where.not(lessons: {id: nil}).where(product_version_id: @course.try(:product_version_id), city: Course.cities[course.try(:city)]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order(:enrolment_end_date).select{|p| !p.enrolments_full?}
      else
        courses = Course.where(product_version_id: course.try(:product_version_id), city: Course.cities[@course.try(:city)]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order(:enrolment_end_date).select{|p| !p.enrolments_full?}
      end

      [show_lesson, enrolment, custom_mock, @course, order, cities, courses]
    end
  end
end
