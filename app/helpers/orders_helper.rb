module OrdersHelper
  def order_present?
    !@order.present?
  end

  def can_checkout
    redirect_to @order, notice: 'One of the items in your cart is no longer purchasable' unless @order.can_checkout?
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

  def verify_valid_course_promo
    code = Promo.find_by(token: params[:promo_code])
    pv_id = params[:pv_id].to_i if params[:pv_id]
    if code && code.product_version_id && (code.product_version_id != pv_id)
      redirect_to(@order, alert: "Discount Code is not valid for this purchase. Please try with another code") and return
    end
  end

  def verify_course_for_user_city
    return unless AdminControl.find_by(name: 'Signup view').try(:new_view)
    if @order.present? && @order.course_id.present?
      @course = Course.find(@order.course_id)
    else
      enrolment = @order.user.enrolments.includes(:order).find_by(orders: { id: @order.try(:id) }) if @order
      @course = enrolment.try(:course)
    end
    return unless @course.present? && @order.ongoing?
    courses = Course.where(product_version_id: @course.product_version_id, city: Course::CITIES[current_user.state.to_sym]).includes(:lessons) if current_user.state.present?
    take_course_path = @order.fetch_show_path(true)
    return if params[:allow_purchase]
    if courses.blank?
      @different_course = true
      redirect_to(take_course_path) and return
    elsif !courses.pluck(:id).include? @course.id
      @different_course = true
      redirect_to(take_course_path) and return
    end
  end
end
