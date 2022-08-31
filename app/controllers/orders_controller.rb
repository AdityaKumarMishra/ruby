class OrdersController < ApplicationController
  include OrdersHelper
  before_action :authenticate_user!, except: [:promo_link, :current_order]
  before_action :set_order_only, only: [:invoice_pdf, :confirm_paid, :redact_order, :share_promo_code, :add_to_cart, :textbook_cart]
  before_action :set_order, only: [:show, :edit, :update, :destroy, :paypal_complete, :direct_complete, :empty_cart, :add_promo, :remove_promo, :braintree_subscription, :payment_success]
  before_action :can_checkout, only: [:paypal_complete, :direct_complete], unless: :format_json?
  after_action :verify_authorized, except: [:index, :display_pending, :new, :promo_link, :share_promo_code, :redact_order, :unsubscribe_popup, :current_order, :client_token, :payment_success, :add_to_cart, :textbook_cart, :invoice_pdf]
  skip_after_action :verify_authorized, only: [:show], unless: :order_present?
  after_action :enrol_student_to_course, only: [:paypal_complete, :direct_complete]
  before_action :verify_expired_promo, only: [:add_promo]
  before_action :verify_valid_course_promo, only: [:add_promo]
  before_action :verify_course_for_user_city, only: [:show]
  layout :resolve_layout

  # Displays all orders
  def index
    @orders = policy_scope(Order)

    @filterrific = initialize_filterrific(
      @orders,
      params[:filterrific]
    ) or return
    @orders = @filterrific.find.paginate(page: params[:page], per_page: 20)
    if current_user.student? && !current_user.confirmed?
      render layout: 'layouts/student_page'
    end
  end

  # Show pending orders
  def display_pending
    authorize Order
    @orders = policy_scope(Order.pending.order(updated_at: :desc).includes(:user, :orders_promos, :promos, purchase_items: [:user]))

    @filterrific = initialize_filterrific(
      @orders,
      params[:filterrific]
    ) or return
    @orders = @filterrific.find.paginate(page: params[:page], per_page: 20)
  end

  # Order invoice PDF generation
  def invoice_pdf
    respond_to do |format|
      format.pdf do
        pdf = InvoicePdf.new(@order)
        send_data pdf.render, filename: "Invoice.pdf", type: 'application/pdf'
      end
    end
  end

  # Order show page
  def show
    if @order.present?
      authorize(@order)
      Orders::RefreshPrices.call(@order)
      @user = @order.user

      if AdminControl.find_by(name: 'Signup view').try(:new_view)
        @user.update_attribute(:payment_flow_step , request.path) if params[:payment_page]
        @order.update_course_detail if @order.course_id.present?

        if current_user.student? && !current_user.paid_courses.present? && (current_user.orders.where(status: :ongoing).present? && current_user.orders.where(status: :ongoing).last.purchase_items.present?) && current_user.payment_flow_step.present?
          redirect_to current_user.payment_flow_step and return if request.path != current_user.payment_flow_step
        end
      end

      @enrolment_items, @courses, @course = Orders::FetchEnrolmentsAndCourses.call(@order)
      session[:promo_token] = nil if session[:promo_token].present? && @order.ongoing? && @order.add_promo(session[:promo_token])
      begin
        @token = Braintree::ClientToken.generate
      rescue
        @token = nil
      end
    end
  end

  # Braintree javacsript client token required by front end
  def client_token
    render json: { client_token: Braintree::ClientToken.generate }, status: :ok
  end

  # Clears all order items
  def empty_cart
    authorize(@order)
    @order.purchase_items.each do |p|
      p.purchasable.try(:deactivate)
      p.destroy

    end
    @order.promos.destroy_all
    @order.destroy
    redirect_to order_path(-1, placeholder: true), notice: 'Cart was successfully emptied.'
  end

  # Goes through and enrols everyone once payment finalised
  # For errors on staging site refer to https://developers.braintreepayments.com/reference/general/testing/ruby
  # Refer to URL for Test amounts, any purchase between 2000-3000 will fail on the stage site however this is meant to happen and will not happen on live
  # Note some guides will have this called as the 'checkout' controller method, due to old paypal integration i dont think that is available for us
  def paypal_complete
    authorize(@order)
    return unless user_email_confirmed?

    nonce = params[:payment_method_nonce]
    device_data = params[:device_data]
    if @order.contains_full_course?
      @order.remove_purchase_items

      redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
    else
      result = @order.braintree_transaction(nonce, device_data)
    end

    respond_to do |format|
      if result.success?
        set_purchase_add_on
        if @order.purchase_items.where(purchasable_type: 'Enrolment').present? && AdminControl.find_by(name: 'Signup view').try(:new_view)
          format.html{ redirect_to payment_success_order_path(@order)}
        else
          format.html { redirect_to @order, notice: 'Successful Purchase' }
        end
        format.json { render json: { message: 'Successful Purchase'}, status: :ok }
      else
        status = result.transaction.try(:status).try(:titleize)
        error = result.message
        format.html { redirect_to @order, notice:  status.to_s + ": " + error }
        format.json { render json: { message: "'We're sorry, there was an error trying to process that transaction.'"}, status: :unprocessable_entity }
      end
    end
  end

  # Makes a pending order payment for bank draft type payments
  def direct_complete
    authorize(@order)
    return unless user_email_confirmed?

    Orders::MarkPaymentPending.call(@order, current_course)
    respond_to do |format|
      if @order.purchase_items.where(purchasable_type: 'Enrolment').present? && AdminControl.find_by(name: 'Signup view').try(:new_view)
        format.html{ redirect_to payment_success_order_path(@order)}
      else
        format.html { redirect_to @order, notice: "It may take between 3 to 5 working days to receive your payment, upon which you will be sent a confirmation email. Please be patient. Alternatively, you may choose to pay via PayPal or Credit Card for immediate access." }
      end
      format.json { render json: { message: "It may take between 3 to 5 working days to receive your payment, upon which you will be sent a confirmation email. Please be patient. Alternatively, you may choose to pay via PayPal or Credit Card for immediate access.", payment_date: @order.created_at.strftime('%d/%m/%Y')}, status: :ok }
    end
  end

  # Admin confirms order to be paid once he/she verifies the bank payment
  def confirm_paid
    authorize(@order)
    @order.authoriser=current_user
    @order.direct_deposit!
    @order.paid!
    course = Course.find_by(id: @order.course_id)
    if @order.contains_full_course?
      @order.remove_purchase_items

      redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
    else
      @order.complete_purchase(course)
    end
    set_purchase_add_on
    redirect_to( '/display_pending_orders', notice: "Payment Confirmed") and return
  end

  # Updates order status to ongoing
  def redact_order
    authorize(@order)
    @order.update(status: 0)
    redirect_to display_pending_orders_path, notice: 'Order cancelled successfully'
  end

  # Adds promocode discount to order
  def add_promo
    authorize(@order)

    respond_to do |format|
      if @order.ongoing?
        unless [Promo::B_PROMOCODE, Promo::B_IR_PROMOCODE].include?(params[:promo_code])
          if @order.add_promo (params[:promo_code] || "")
            format.html { redirect_to @order, notice: "Discount applied!"}
            format.json { render :discount_info, status: :ok }
          else
            notice = @order.errors.full_messages.first
            notice = "Could not apply discount code" if notice.nil? || notice.empty?
            format.html { redirect_to @order, notice: notice }
            format.json { render json: { message: notice }, status: 406 }
          end
        else
          format.html { redirect_to @order, alert: "Cannot apply this discount. Invalid discount code!" }
          format.json { render json: { message: "Cannot apply discount as the code us invalid" }, status: 400 }
        end
      else
        format.html { redirect_to @order, notice: "Cannot apply discount after order is finalised" }
        format.json { render json: { message: "Cannot apply discount after order is finalised" }, status: 400 }
      end
    end
  end

  # Remove promo code for order
  def remove_promo
    authorize(@order)

    token = Promo.find_by_token(params[:promo_code])
    respond_to do |format|
      if token
        @order.promos.delete(token)
        format.html {  redirect_to @order, notice: "Removed discount code" }
        format.json { render :discount_info, status: :ok }
      else
        format.html {  redirect_to @order, notice: "Promo code not found" }
        format.json { render json: {message: "Promo code not found"}, status: 400 }
      end
    end
  end

  # Render special page for social media bots
  def promo_link
    return render 'orders/promo_link', layout: false if Promo::SOCIAL_MEDIA_CRAWLERS.include?(request.user_agent)

    token = session[:promo_token] = params[:token].upcase
    promo = Promo.find_by_token(token)
    promo.visit! unless promo.nil?

    redirect_to(current_user.present? ? current_user.validate_order : new_user_session_url)
  end

  # Sharing promo code with the specified emails
  def share_promo_code
    emails =  params[:email].split(/\s*,\s*/)
    emails.each do |email|
      mail = OrdersMailer.promo_shared(email, @order)
      mail.deliver
      flash[:notice] = "Promo code has been shared successfully."
    end
    redirect_to order_url(@order)
  end

  def unsubscribe_popup
    current_user.update(seen_discount_popup: true)
    redirect_back_with_fallback root_path,
                                notice: "You won't see the popup to share your discount link any more! Go to past orders to find the discount link again."
  end

  # Payment success page after order completion
  def payment_success
    current_user.update_attribute(:payment_flow_step, nil)
    EnrolmentsMailer.enrolment_order_received(current_user).deliver_later unless current_user.enrolments.last.paid_at.present?
    render layout: 'layouts/student_page'
  end

  # For adding course to cart from the course details page
  def add_to_cart
    purchase_item, feature_log = Orders::AddToCart.call(@order, params[:pvfp_id], params[:enrolment_id], params[:qty], current_user)
    render json: { purchase_item_id: purchase_item.id, master_feature_id: feature_log.master_feature.id }
  end

  # For updating enrolment hardcopy and online textbook options
  def textbook_cart
    feature_log = Orders::TextbookCart.call(@order, params, current_user)
    args = feature_log.present? ? { purchase_item_id: feature_log.reload.purchase_item.try(:id), master_feature_id: feature_log.master_feature.id } : {nothing: true}
    render json: args
  end

  private

  def set_order
    if current_user.student?
      @order = current_user.orders.find_by(id: params[:id])
      @order.recalculate_discounts! if @order
    else
      @order = Order.find_by(id: params[:id])
    end

    if @order.present?
      transaction_products = Orders::TransactionProducts.call(@order)
      gon.orderData = {
        transactionId: @order.id.to_s,
        transactionTotal: @order.total_initial_cost,
        transactionShipping: @order.total_shipping_cost,
        transactionTax: @order.total_added_gst,
        transactionProducts: transaction_products
      }
    end
  end

  def order_present?
    !@order.present?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:user_id, :devise_data, :payment_method_nonce)
  end

  def can_checkout
    if @order.present? && !@order.can_checkout?
      @order.remove_purchase_items
      redirect_to @order, alert: "The course you are trying to purchase is currently full. Please enroll in another course"
    end
  end

  def format_json?
    request.format.json?
  end

  def set_purchase_add_on
    enrolment_ids = if current_course
                      current_course.enrolments.includes(:order).where('orders.user_id =?', current_user.id).references(:orders).pluck(:id)
                    else
                      current_user.enrolments.pluck(:id)
                    end
  end

  def enrol_student_to_course
    if session[:current_enrolment] && session[:current_order]
      order = Order.find(session[:current_order])
      if order.paid?
        enrolment = Enrolment.find(session[:current_enrolment])
        enrolment.purchase_item.update(user_id: current_user.id)
        session[:current_enrolment] = nil
        session[:current_order] = nil
      end
    end
  end

  def verify_expired_promo
    code = Promo.find_by(token: params[:promo_code])
    if code && code.expiry_date && code.expiry_date < Time.zone.today
      redirect_to(@order, alert: "Discount Code is Expired. Please try with another code") and return
    end

  end

  def user_email_confirmed?
    if current_user.confirmed_at.blank?
      respond_to do |format|
        format.html do
          redirect_to @order, notice:  'Please confirm your email to complete your purchase.'
        end
        format.json do
          render(
            json: {
              message: 'Please confirm your email to complete your purchase.'
            },
            status: :unprocessable_entity
          )
        end
      end
      false
    else
      true
    end
  end

  def set_order_only
    @order = Order.find_by(id: params[:id])
  end

  def resolve_layout
    current_user.student? && ['index', 'show'].include?(action_name) ? 'student_page' : 'dashboard'
  end
end
