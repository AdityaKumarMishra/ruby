class PurchaseAddonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase_addon, only: [:show, :edit, :update, :destroy]
  include PayPal::SDK::REST

=begin
  This controller / model is no longer being used and is only being kept for people who once purchased PurchaseAddons
  This was replaced by the feature_enrolment controller
=end


  # GET /purchase_addons
  # GET /purchase_addons.json
  def index
    if current_user.student?
      redirect_to "/dashboard/purchase_addons"
    end
    @purchase_addons = PurchaseAddon.all

  end

  # GET /purchase_addons/1
  # GET /purchase_addons/1.json
  def show
    if current_user.student?
      redirect_to "/dashboard/purchase_addons"
    end
  end

  # GET /purchase_addons/new
  def new
    if current_user.student?
      redirect_to "/dashboard/purchase_addons"
    end
    @purchase_addon = PurchaseAddon.new
  end

  # GET /purchase_addons/1/edit
  def edit
    if current_user.student?
      redirect_to 'dashboard/purchase_addons'
    end
  end

  # GET /dashboard/purchase_addon
  def _purchase_addon
    # Assuming that the last enrolment of the user is the valid one
    # for now
    if(current_user.paid_enrolments.count > 0)
      @inactive_features = current_user.paid_enrolments.last.course.product_version.inactive_features
    else
      @inactive_features = nil
    end
  end

  # POST /dashboard/purchase_addon/#

  # POST /purchase_addons
  # POST /purchase_addons.json
  def create
    @purchase_addon = PurchaseAddon.new(purchase_addon_params)

    respond_to do |format|
      if @purchase_addon.save
        format.html { redirect_to @purchase_addon, notice: 'Purchase addon was successfully created.' }
        format.json { render :show, status: :created, location: @purchase_addon }
      else
        format.html { render :new }
        format.json { render json: @purchase_addon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_addons/1
  # PATCH/PUT /purchase_addons/1.json
  def update
    respond_to do |format|
      if @purchase_addon.update(purchase_addon_params)
        format.html { redirect_to @purchase_addon, notice: 'Purchase addon was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase_addon }
      else
        format.html { render :edit }
        format.json { render json: @purchase_addon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_addons/1
  # DELETE /purchase_addons/1.json
  def destroy
    @purchase_addon.destroy
    respond_to do |format|
      format.html { redirect_to purchase_addons_url, notice: 'Purchase addon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_addon
      @purchase_addon = PurchaseAddon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_addon_params
      params.require(:feats).permit(:paid_at, :date_activated, :date_deactivated, :features, :subtotal, :gst, :paypal_fee, :paypal_payment, :paypal_token, :paypal)
    end

  def redirect_url(payment)
    payment.links.find { |v| v.method == 'REDIRECT' }.href
  end
end
