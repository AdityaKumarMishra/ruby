module Orders
  class FetchEnrolmentsAndCourses
    attr_accessor :order, :enrolment_items, :user

    def initialize(order)
      @order = order
      @enrolment_items = order.purchase_items.where(purchasable_type: 'Enrolment')
      @user = order.user
    end

    class << self
      def call(order)
        new(order).call
      end
    end

    def call
      if @enrolment_items.empty? && @user&.has_free_trial_only?
        custom_order = @order.user.orders.includes(:purchase_items).where('purchase_items.purchase_description LIKE ? ', '%Custom course for Free trail%').references(:purchase_items).first
        enrolments = @order.user.enrolments.includes(:order).where(orders: { id: custom_order.try(:id) })
      elsif @enrolment_items.empty?
        enrolments = Enrolment.where(id: @order.user.paid_enrolments.first)
      else
        enrolments = Enrolment.where(id: @enrolment_items.pluck(:purchasable_id))
      end

      courses = Course.where(id: enrolments.pluck(:course_id))
      [@enrolment_items, courses, courses.first]
    end
  end
end