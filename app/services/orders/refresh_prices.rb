module Orders
  class RefreshPrices
    attr_accessor :order

    def initialize(order)
      @order = order
    end

    class << self
      def call(order)
        new(order).call
      end
    end

    def call
      return unless @order.ongoing?

      @order.purchase_items.each do |pur_course|
        if pur_course.purchasable_type == 'Enrolment'
          new_price = pur_course.purchasable.course.product_version.price
          if (pur_course.initial_cost != new_price && pur_course.purchasable_type == 'Enrolment' && new_price != 0.0)
            new_gst = BigDecimal.new("0.1")*new_price
            pur_course.update(initial_cost: new_price, added_gst: new_gst)
          end
        end
        if pur_course.purchasable
          purchase_course = pur_course.purchasable.try(:course)
          if pur_course.purchasable_type == 'Enrolment'
            pur_course.destroy if purchase_course.expiry_date < Time.zone.now.beginning_of_day || purchase_course.enrolment_end_date < Time.zone.now.beginning_of_day
          else
            pur_course.destroy if purchase_course.expiry_date.nil? || purchase_course.expiry_date < Time.zone.now.beginning_of_day
          end
        end
      end
    end
  end
end
