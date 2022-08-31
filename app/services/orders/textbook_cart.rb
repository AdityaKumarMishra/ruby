module Orders
  class TextbookCart
    attr_accessor :order, :params, :current_user

    def initialize(order, params, current_user)
      @order = order
      @params = params
      @current_user = current_user
    end

    class << self
      def call(order, params, current_user)
        new(order, params, current_user).call
      end
    end

    def call
      pvfp = ProductVersionFeaturePrice.find_by(id: params[:pvfp_id])
      enrolment = Enrolment.find(params[:enrolment_id])
      if pvfp.present? && pvfp.master_feature.hardcopy?
        feature_log = pvfp.enrolment_feature_log(current_user.try(:id), enrolment.try(:id))
        unless feature_log.purchase_item.present?
          initial_cost = pvfp.price_after_discount
          shipping_cost = current_user.textbook_shipping_cost
          purchase_item = feature_log.create_purchase_item(initial_cost: initial_cost,
                                                           user_id: current_user.id,
                                                           shipping_cost: shipping_cost,
                                                           purchase_description: pvfp.master_feature.title,
                                                           order_id: @order.id)
        end
      end
      enrolment.update(online_textbook: ActiveModel::Type::Boolean.new.cast(params['online_check']),
                       hardcopy: ActiveModel::Type::Boolean.new.cast(params['hardcopy_checked']))

      if params['online_check'] == 'true' && params['hardcopy_checked'] == 'false'
        feature_log.purchase_item.destroy if feature_log.present?
      elsif params['online_check'] == 'true' && params['hardcopy_checked'] == 'true'
        if feature_log.present?
          initial_cost = pvfp.price_after_discount
          feature_log.purchase_item.update(initial_cost: initial_cost) rescue nil
        else
          feature_log = enrolment.feature_logs.includes(:master_feature).where('master_features.name LIKE(?)', '%TextbookHardCopyFeature%').references(:master_features).first
          initial_cost = feature_log.try(:product_version_feature_price).try(:price_after_discount)
          feature_log.purchase_item.update(initial_cost: initial_cost) rescue nil
        end
      elsif params['online_check'] == 'false' && params['hardcopy_checked'] == 'true'
        if feature_log.present?
          feature_log.purchase_item&.update(initial_cost: 0, added_gst: 0)
        else
          feature_log = enrolment.feature_logs.includes(:master_feature).where('master_features.name LIKE(?)', '%TextbookHardCopyFeature%').references(:master_features).first
          feature_log.purchase_item&.update(initial_cost: 0, added_gst: 0) if feature_log.present?
        end
      elsif params['online_check'] == 'false' && params['hardcopy_checked'] == 'false'
        feature_log.purchase_item&.destroy if feature_log.present?
      end

      feature_log
    end
  end
end
