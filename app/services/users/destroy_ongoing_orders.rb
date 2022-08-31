module Users
  class DestroyOngoingOrders
    attr_accessor :current_user

    def initialize(current_user)
      @current_user = current_user
    end

    class << self
      def call(current_user)
        new(current_user).call
      end
    end

    def call
      if current_user&.enrolments&.count >= 1 || Rails.env == 'test'
        current_user.orders.where(status: :ongoing).each do |order|
          order.remove_purchase_items
          order.destroy
        end
      end
    end
  end
end
