module Orders
  class AddToCart
    attr_accessor :order, :pvfp_id, :enrolment_id, :qty, :current_user

    def initialize(order, pvfp_id, enrolment_id, qty, current_user)
      @order = order
      @pvfp_id = pvfp_id
      @enrolment_id = enrolment_id
      @qty = qty
      @current_user = current_user
    end

    class << self
      def call(order, pvfp_id, enrolment_id, qty, current_user)
        new(order, pvfp_id, enrolment_id, qty, current_user).call
      end
    end

    def call
      pvfp = ProductVersionFeaturePrice.find(@pvfp_id)
      enrolment = Enrolment.find(@enrolment_id)

      if @qty.present? && !pvfp.master_feature.mcq_feature?
        pvfp = ProductVersionFeaturePrice.find_by(product_version_id: pvfp.product_version_id, master_feature_id: pvfp.master_feature_id, qty: @qty)
      end

      feature_log = pvfp.enrolment_feature_log(current_user.id, enrolment.id)
      course_type = ProductVersion.course_types[pvfp.product_version.try(:course_type)]
      total_cost = course_type == 1 || course_type == 11 ? pvfp.ten_percent_gst_amount : pvfp.price_after_discount

      added_gst = ((10 * total_cost) / 100).ceil
      initial_cost = total_cost - added_gst

      if pvfp.master_feature.mcq_feature?
        initial_cost = @qty.to_i * 0.1
        feature_log.update(qty: @qty)
      end

      shipping_cost = 0
      shipping_cost = current_user.textbook_shipping_cost if pvfp.master_feature.hardcopy?
      purchase_item = feature_log.create_purchase_item(initial_cost: initial_cost,
                                       user_id: current_user.id,
                                       shipping_cost: shipping_cost,
                                       purchase_description: pvfp.master_feature.title,
                                       order_id: @order.id,
                                       added_gst: added_gst)

      [purchase_item, feature_log]
    end
  end
end