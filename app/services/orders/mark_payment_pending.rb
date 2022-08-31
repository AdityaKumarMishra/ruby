module Orders
  class MarkPaymentPending
    attr_accessor :order, :current_course

    def initialize(order, course)
      @order = order
      @current_course = course
    end

    class << self
      def call(order, course)
        new(order, course).call
      end
    end

    def call
      @order.direct_deposit!
      unless @order.purchase_items.pluck(:purchasable_type).include?('Enrolment')
        @order.course_id = @order.user.active_course.try(:id)
      end
      @order.pending!
      @order.purchase_items.each do |purchase|
        if current_course.present? && (current_course.trial_enabled || current_course.expired?) && purchase.purchasable_type == "FeatureLog"
          feature_log = purchase.purchasable
          order2 = feature_log.enrolment.order
          @order.course_id = feature_log.enrolment.course_id
          @order.save
          order2.update(status: :free, paid_at: Time.zone.now) if order.present? && order.status == 'ongoing'
        end
        method_fee = 0
        purchase.update(method_fee: method_fee)
      end
      @order.set_redundant_cost
      if ENV['EMAIL_CONFIRMABLE'] != "false"
        if @order.user.confirmed_at.present?
          OrdersMailer.staff_new_banktrans(@order).deliver_later
          if @order.purchase_items.try(:last).try(:purchasable_type) == "Enrolment" && @order.purchase_items.try(:last).try(:purchasable).try(:course).present?
            course = @order.purchase_items.try(:last).try(:purchasable).try(:course)
            CoursesMailer.course_full_alert(course).deliver_later if course.present? && course.full_alert?
          end
        else
          @order.user.mail_pendings.create(order_id: @order.id, category: "OrdersMailer", method: 'staff_new_banktrans(order)', status: 0)
        end
      end
    end
  end
end
