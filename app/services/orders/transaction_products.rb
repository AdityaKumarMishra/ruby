module Orders
  class TransactionProducts
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
      @order&.purchase_items&.includes(purchasable: :course)&.map do |purchase_item|
        pv = purchase_item.purchasable.is_a?(Enrolment) ? purchase_item.purchasable.product_version : purchase_item.purchasable.enrolment.product_version
        pv_name = pv.type.present? ? pv.type.split('Ready').first : ''
        pv_name.upcase! if ['Vce', 'Hsc'].include?(pv_name)

        {
          name: purchase_item.purchasable.is_a?(Enrolment) ? purchase_item.purchasable.course.name : purchase_item.purchasable.enrolment.course.name,
          sku: purchase_item.purchasable.is_a?(Enrolment) ? purchase_item.purchasable.course.id.to_s : purchase_item.purchasable.enrolment.course.id.to_s,
          category: pv_name,
          price: purchase_item.initial_cost,
          quantity: 1
        }
      end
    end
  end
end
