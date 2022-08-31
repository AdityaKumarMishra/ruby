module Users
  class FetchCourseDetails
    attr_accessor :user, :request_path

    def initialize(user, request_path)
      @user = user
      @request_path = request_path
    end

    class << self
      def call(user, request_path)
        new(user, request_path).call
      end
    end

    def call
      outofstock = OutOfStock.first
      custom_course_order = user.orders
                                .reload
                                .includes(:purchase_items)
                                .where("status = 6 AND purchase_items.purchase_description ILIKE '%custom%'")
                                .references(:purchase_items).first

      order = !user.validate_order_presence && custom_course_order.present? ? custom_course_order : user.validate_order
      user.update_attribute(:payment_flow_step , request_path) if AdminControl.find_by(name: 'Signup view').try(:new_view)
      enrolment_items = order.purchase_items.select{|purchase| purchase.purchasable.class.name == "Enrolment"}
      notification = Notification.find_by(page_type: "course_details")
      if enrolment_items.empty? && user.has_free_trial_only?
        custom_order = user.orders.includes(:purchase_items).where('purchase_items.purchase_description LIKE ? ', '%Custom course for Free trail%').references(:purchase_items).first
        enrolment = user.enrolments.includes(:order).find_by(orders: { id: custom_order.try(:id) })
        course = enrolment.try(:course)
      else
        enrolment = user.enrolments.includes(:order).where(orders: { id: order.try(:id) }).last
        course = enrolment.try(:course)
      end

      [outofstock, order, user, enrolment_items, notification, enrolment, course]
    end
  end
end
