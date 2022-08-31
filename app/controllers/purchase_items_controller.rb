class PurchaseItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase_item, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :new]

  def destroy
    authorize @purchase_item
    purchasable_item = @purchase_item.purchasable
    order = @purchase_item.order
    if @purchase_item.destroy
      order.promos.destroy_all if order.purchase_items.empty?
      if @purchase_item.purchasable_type == 'FeatureLog' && @purchase_item.purchasable.present? && @purchase_item.purchasable.allow_delete?
        purchasable_item.destroy
      end
    end

    from_order_page = request.referrer.split('/').include?('orders')
    destroy_order = from_order_page && order.reload.purchase_items.empty?
    order.destroy if destroy_order

    respond_to do |format|
      format.html do
        if destroy_order
          redirect_to(order_path(-1, placeholder: true), notice: 'Item was successfully removed')
        else
          redirect_back fallback_location: feature_logs_path, notice: 'Item was successfully removed'
        end
      end
      format.json { head :no_content }
    end
  end

  private

  def set_purchase_item
    @purchase_item = PurchaseItem.find_by(id: params[:id])
    if @purchase_item.present?
      @original_user=@purchase_item.user
      authorize @purchase_item
    else
      redirect_back fallback_location: feature_logs_path
    end
  end



  def purchase_item_params
    params.require(:purchase_item).permit(:initial_cost, :shipping_cost, :gst, :status, :purchase_type, :card_id, :user_id, :purchasable_type, :purchasable_id)
  end

end
