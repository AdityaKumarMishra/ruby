class EnrolmentsController < ApplicationController
  # t.string   "name"
  # t.float    "price"
  # t.string   "type"
  # t.datetime "created_at", null: false
  # t.datetime "updated_at", null: false
  # t.string   "slug"

  before_action :authenticate_user!, except: [:quick_enrol, :attach_enrolment_details]
  before_action :set_course, only: [:enrol, :quick_enrol, :cancel, :paypal_payment, :student_course_enrolment, :transfer_payment, :create, :new, :transfer_course, :custom_enrol]
  before_action :set_student, except: [:enrol, :quick_enrol, :cancel, :paypal_payment,
                                       :transfer_payment, :show, :student_addon_enrolment,  :custom_enrol]
  before_action :set_enrolment, only: [:unenrol_or_renrol, :edit, :update, :destroy]
  before_action :set_features, only: [:enrol, :quick_enrol, :cancel, :paypal_payment,
                                      :transfer_payment,  :custom_enrol]
  before_action :ensure_course_is_not_quick_enrolled, only: [:quick_enrol]
  before_action :set_features, only: [:enrol, :student_course_enrolment, :cancel, :paypal_payment,
                                      :transfer_payment, :transfer_course,  :custom_enrol]
  before_action :verify_purchased_course, only: [:quick_enrol]
  # before_action :ensure_course_is_not_enrolled, only: [:enrol, :custom_enrol]
  before_action :ensure_student_course_enrolment, only: [:student_course_enrolment, :transfer_course]
  after_action :verify_authorized, except: [:new]
  # before_action :verify_course_for_user_city, only: [:enrol, :custom_enrol]
  before_action :generate_shipping_cost, only: [:enrol]
  before_action :set_active_courses, only: %i[new edit transfer_by]

  def show
    @enrolment = Enrolment.find(params[:id])
    authorize(@enrolment)
    order = @enrolment.order
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(order)
        send_data pdf.render, filename: "Invoice.pdf", type: 'application/pdf'
      end
    end
  end

  def unenrol_or_renrol
    @enrolment.update(state: params[:new_state])
    message = params[:new_state] == 'Unenrolled' ? 'Successfully unenrolled student from course' : 'Successfully re-enrolled student into course'

    redirect_to edit_user_path(@enrolment.user), notice: message
  end


  def new
    @enrolment = @course.enrolments.new
    @enrolment.paid! if @enrolment.paid?
  end

  def enrol
    pv = @course.product_version
    @enrolment = Enrolment.create(course_id: @course.id)
    authorize(@enrolment)
    if pv.present? && pv.archived?
      @enrolment.destroy
      flash[:error] = 'Cannot purchase course since Product Version is archived. Please contact support team if any updates required.'
      redirect_to gamsat_path
    else
      if @course.trial_enabled?
        if @enrolment.valid? && @enrolment.valid_for_purchase?
          @order = Order.create(user_id: current_user.id, creator_id: current_user.id, status: :free,
                                purchase_method: :direct_deposit)
          @enrolment.update(trial: true, trial_expiry: Time.zone.now + @course.trial_period_days.days)
          @enrolment.create_purchase_item(
            initial_cost: 0, user_id: current_user.id,
            purchase_description: "#{@course.product_version.name} #{@course.product_version.type}",
            order_id: @order.id
          )
          if @order.contains_full_course?
            @order.remove_purchase_items

            redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
          else
            @order.complete_purchase(@course)
          end
          if @enrolment.reload.paid?
            SystemInfo.find_or_create_by(ip: request.ip, user_agent: request.user_agent, product_line: @course.product_version.type)
            redirect_to(update_contact_user_path(current_user), notice: 'Trial Course Bought') && return
          else
            @enrolment.destroy
            msg = "You have already enrolled into a Trial Course. Please click #{view_context.link_to('here',  contact_path)} if you would like to submit a query"
            take_course_path = @course.product_version.fetch_show_path
            redirect_to(take_course_path, alert: msg) && return
          end
        else
          take_course_path = @course.product_version.fetch_show_path
          redirect_to(take_course_path, alert: @enrolment.errors.full_messages.join(', ')) && return
        end
      else
        # Did 0,1 to deal with floating point arithmetic,
        # ideally everything should be decimal
        if @course.price <= 0.1
          @order = Order.create(user_id: current_user.id, creator_id: current_user.id, status: :free,
                                purchase_method: :direct_deposit)
          @enrolment.create_purchase_item(
            initial_cost: @course.price, user_id: current_user.id,
            shipping_cost: @shipping_cost,
            purchase_description: @course.product_version.name + ' ' +
              @course.product_version.type,
            order_id: @order.id
          )
          if @order.contains_full_course?
            @order.remove_purchase_items

            redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
          else
            @order.complete_purchase(@course)
          end
          view_type = AdminControl.find_by(name: 'Signup view')
          if view_type.present? && view_type.new_view
            redirect_to update_contact_user_path(current_user)
          end
          # redirect_to(dashboard_home_path, notice: 'Custom Course Bought') && return
          return
        else
          @order = current_user.reload.validate_order
          args = {}
          previous_course_removed = ''
          previous_order_courses = Course.where(id: Enrolment.where(id: @order.purchase_items.map{ |p| p.purchasable.try(:enrolment_id) || p.purchasable.id }.compact.uniq).pluck(:course_id).uniq)

          if previous_order_courses.present? && (previous_order_courses.count > 1 || previous_order_courses.first.id != @course.id)
            @order.remove_purchase_items
            previous_course_removed = 'Please note that your previous incomplete order has been replaced by this current order. Please complete purchase 1 course at at time.'
            args = {
              notice: previous_course_removed
            }
          end

          @enrolment.create_purchase_item(
            initial_cost: @course.price,
            shipping_cost: @shipping_cost,
            user_id: current_user.id,
            purchase_description: @course.product_version.name + ' ' +
              @course.product_version.type,
            order_id: @order.id
          )
          @order.set_discount_if_expired_exists(current_user)
          view_type = AdminControl.find_by(name: 'Signup view')
          if view_type.present? && view_type.new_view && current_user.address.present?
            current_user.update_attribute(:payment_flow_step , course_details_user_path(current_user))
            redirect_to course_details_user_path(current_user), **args
          elsif view_type.present? && view_type.new_view
            redirect_to update_contact_user_path(current_user), **args
          else
            redirect_to(current_user.reload.validate_order, notice: "Item added to cart. #{previous_course_removed}")
          end
          CoursesMailer.course_full_alert(@course).deliver_later if @course.full_alert? && ENV['EMAIL_CONFIRMABLE'] != "false"

          return
        end
      end
    end
  end

  def student_course_enrolment
    @enrolment = @student.enrolments.where(course_id: @course.id).first
    @enrolment.update(state: Enrolment.states['Manual Enrolment']) if @enrolment.present?

    @enrolment = Enrolment.create(course_id: @course.id, state: Enrolment.states['Manual Enrolment']) if @enrolment.blank?
    authorize(@enrolment)
    if @enrolment.valid?
      @order = Order.create(user_id: @student.id, creator_id: current_user.id, status: :ongoing,
                            purchase_method: :direct_deposit)
      @enrolment.create_purchase_item(
        initial_cost: @course.price, user_id: @student.id,
        purchase_description: "#{@course.product_version.name} #{@course.product_version.type}",
        order_id: @order.id
      )
      @enrolment.update(trial: true, trial_expiry: Time.zone.now + @course.trial_period_days.days) if @course.trial_enabled?

      if @order.contains_full_course?
        @order.remove_purchase_items

        redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
      else
        @order.update(status: %w[free_trial free_study_guide].include?(@course.product_version&.course_type) ? :free : :paid)
        @order.complete_purchase(@course)
      end

      redirect_to(edit_user_path(@student), notice: 'Student enroled Successfully')
    else
      redirect_to(edit_user_path(@student), alert: @enrolment.errors.full_messages.join(', ')) && return
    end
  end

  def quick_enrol
    @enrolment = Enrolment.create(course_id: @course.id)
    authorize(@enrolment)
    @order = Order.create(status: :ongoing, creator_id: current_user.id)
    session[:current_enrolment] = @enrolment.id
    session[:current_order] = @order.id
    @enrolment.create_purchase_item(
      initial_cost: @course.price,
      purchase_description: @course.product_version.name + ' ' +
        @course.product_version.type,
      order_id: @order.id,
    )
    redirect_to(quick_pay_sign_up_order_path(@order))
    return
  end

  def attach_enrolment_details
    authorize Enrolment
    if session[:current_enrolment] && session[:current_order]
      enrolment = Enrolment.find(session[:current_enrolment])
      order = Order.find(session[:current_order])
      result = true
      result &&= order.update_columns(user_id: params[:user_id])

      if result
        render json: { order_id: session[:current_order], course_id: enrolment.course_id, reference_number: order.reference_number, discount_rate: order.paypal_addon * 100 }, status: :ok
      else
        render json: {}, status: :unprocessable_entity
      end
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def edit
    authorize @enrolment
    @enrolment.paid!
    product_version_id = @enrolment.course.product_version.id

    @features = ProductVersionFeaturePrice.includes(
      :master_feature, :feature_logs
    ).where('feature_logs.enrolment_id =?', @enrolment.id
           ).references(:feature_logs).where(product_version_id: product_version_id
                  )
    @student = User.friendly.find(params[:user_id])
    course_id = @enrolment.course_id
    @exams = @student.assessment_attempts.where(assessable_type: "OnlineExam", course_id: course_id)
    @mock_exams = @student.online_mock_exam_attempts.joins(:online_mock_exam).where("online_mock_exams.city = ?", OnlineMockExam.cities[@enrolment.course.city]).to_a.uniq
    @essay = @student.essay_responses.where(course_id: course_id).joins(:essay).sort{|a, b| b.title.gsub("Essay ","").to_i <=> a.title.gsub("Essay ","").to_i }
    @not_submit_essay = @student.essay_responses.where('time_submited IS NULL AND status = 0 AND expiry_date >= ? AND course_id = ?',Time.zone.now.in_time_zone("Australia/Queensland"),course_id)
    @submit_essay = @student.essay_responses.where('time_submited IS NOT NULL AND status = 1 AND course_id = ?', course_id)
    @expired_essay = @student.essay_responses.where('time_submited IS NULL AND status = 0 AND expiry_date < ? AND course_id = ?',Time.zone.now.in_time_zone("Australia/Queensland"), course_id)
    @marked_essay = @student.essay_responses.where('status = 2 OR status = 3 AND time_submited IS NOT NULL AND course_id = ?', course_id)
  end

  def create
    @enrolment = @course.enrolments.new(enrolment_params)
    authorize @enrolment
    respond_to do |format|
      if @enrolment.save
        format.html do
          redirect_to user_enrolment_path(@student, @enrolment),
                      notice: 'Enrolment was successfully created.'
        end
        format.json { render :show, status: :created, location: @enrolment }
      else
        format.html { render :new }
        format.json do
          render json: @enrolment.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def update
    authorize @enrolment
    respond_to do |format|
      if @enrolment.update(enrolment_params)
        format.html do
          redirect_to user_enrolment_path(@student, @enrolment),
                      notice: 'Enrolment was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @enrolment }
      else
        format.html { render :edit }
        format.json do
          render json: @enrolment.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    authorize @enrolment
    order = @enrolment.order
    @essay_responses = EssayResponse.where(user_id: @enrolment.user.id, course_id: @enrolment.course_id)
    @dates = @essay_responses.pluck(:expiry_date)
    @enrolment.destroy
    @essay_responses.destroy_all if @essay_responses.present?
    order.destroy if order.present?
    send_essay_count_mail(@dates, @enrolment) if @dates.present?
    respond_to do |format|
      format.html do
        redirect_to edit_user_path(@student),
                    notice: 'Enrolment was successfully destroyed'
      end
      format.json { head :no_content }
    end
  end


  def send_essay_count_mail(dates, enrolment)
    ids = enrolment.course.staff_profiles

    @responses = EssayResponse.includes(course: :staff_profiles).where('courses.expiry_date > ? AND essay_responses.status IN (?) AND essay_responses.expiry_date > ?', Time.zone.now.in_time_zone("Australia/Melbourne"), [0,1], Time.zone.now.in_time_zone("Australia/Melbourne")).references(:courses).includes(:user).where.not(users: { confirmed_at: nil })

    ids.each do |id|
      dates.each do |date|
        res_count = @responses.where(staff_profiles: {id: id}, expiry_date: date).count
        if ((res_count != 0) && (res_count % 5 == 0) || res_count > 25)
          EssayResponseMailer.essay_marking_reminder(res_count, date.strftime("%d/%m/%Y"), id).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        end
      end
    end
  end

  # def paypal_payment
  # PUtting this here if we need to put back paypal system
  #   # use find_or_create?
  #   @enrolment = @course.enrolments.build(user: current_user)
  #   payment = Payment.new(@course.paypal_hash(paypal_execute_url,
  #                                             paypal_cancel_url))
  #   respond_to do |format|
  #     if payment.create
  #       @enrolment.paypal_payment = payment.id
  #       # save token for cancel url to delete enrolment
  # @enrolment.paypal_token = CGI.parse(
  #   URI(redirect_url(payment)).query
  # )['token'].first
  #       # make sure this always saves without exception.
  #       @enrolment.subtotal = @course.price
  #       @enrolment.gst = @course.tax
  #       @enrolment.paypal_fee = @course.paypal_fee
  #       @enrolment.save
  #       format.html { redirect_to redirect_url(payment) }
  #     else
  #       format.html { render :new }
  # format.json do
  #   render json: { error: 'Payment is not saved' },
  #          status: :unprocessable_entity
  # end
  #     end
  #   end
  # end

  def student_addon_enrolment
    @enrolment = Enrolment.find(params[:id])
    authorize @enrolment
    @student = @enrolment.user
    pvfp1 = ProductVersionFeaturePrice.find(params[:pvfp_id])
    master_feature = pvfp1.master_feature

    if (master_feature.private_tutoring? || master_feature.essay? || master_feature.exam_feature?)
      pvfp = ProductVersionFeaturePrice.create!(pvfp1.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :price, :qty, :subtype_change_date, :is_additional).merge(qty: (params[:quantity] || 1).to_i, price: (pvfp1.price * (params[:quantity] || 1).to_i), is_additional: true))
      pvfp.tags << pvfp1.tags
      pvfp.save!
    else
      pvfp = pvfp1
    end

    unless (master_feature.private_tutoring? || master_feature.essay? || master_feature.exam_feature?)
      params[:positive_val] = 'true'
    end
    if(params[:positive_val] == 'true')
      if params[:enrol] == 'true'
        if @enrolment.present?
          @order = Order.create(user_id: @student.id, creator_id: current_user.id, status: :paid,
                                purchase_method: :direct_deposit)
          initial_cost = 0
          master_feature = pvfp.master_feature
          feature_log = pvfp.enrolment_feature_log(@student.id, @enrolment.id, params[:quantity])
          feature_log.create_purchase_item(
            initial_cost: initial_cost, user_id: @student.id,
            purchase_description: feature_log.product_version_feature_price.subtype == 'subtype_1' ? "#{feature_log.qty} #{master_feature.title}" : master_feature.title,
            order_id: @order.id
          )

          if @order.contains_full_course?
            @order.remove_purchase_items

            redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
          else
            @order.complete_purchase(@enrolment.course, nil, nil, true, true, feature_log.qty)
          end

          @order.customise_email_template_for_master_feature_manual(master_feature)
          flash[:notice] = 'Student enroled Successfully'
        else
          flash[:error] = @enrolment.errors.full_messages.join(', ')
        end
      else
        feature_log = pvfp.enrol_feature_log(@student.id, @enrolment.id, master_feature.id)
        feature_log.find_each { |f| f.deactivate_feature(@enrolment.course) }
        flash[:notice] = 'Student feature is successfully removed'
      end
      render js: "window.location = '#{edit_user_enrolment_path(@student, @enrolment)}'"
    else
      deactivate_enroled_feature
    end
  end

  def deactivate_enroled_feature
    @enrolment = Enrolment.find(params[:id])
    authorize @enrolment
    @student = @enrolment.user
    pvfp = ProductVersionFeaturePrice.find(params[:pvfp_id])
    minus_qty = pvfp.qty
    feature_logs =  @enrolment.user.feature_logs.joins(:product_version_feature_price).where("acquired IS NOT NULL AND enrolment_id IN (?) AND product_version_feature_prices.product_version_id = ? AND product_version_feature_prices.master_feature_id = ?",  [@enrolment.id], pvfp.product_version_id, pvfp.master_feature_id).order(qty: :desc)
    is_del_feature_log = true
    if feature_logs.pluck(:qty).include? minus_qty
      feature_log = feature_logs.find_by(qty: minus_qty)
      feature_log.deactivate_feature(@enrolment.course)
    elsif minus_qty < feature_logs.first.qty
      last = feature_logs.first
      new_qty = last.qty - minus_qty
      is_del_feature_log = create_new_feature_log(pvfp, new_qty)
      last.deactivate_feature(@enrolment.course) if is_del_feature_log
    elsif minus_qty >= feature_logs.first.qty
      del_feature_logs = []
      sum = 0
      feature_logs.each do |feature_log|
        del_feature_logs << feature_log
        sum += feature_log.try(:qty)
        break if sum >= minus_qty
      end
      if sum > minus_qty
        new_qty = sum - minus_qty
        is_del_feature_log = create_new_feature_log(pvfp, new_qty)
      end
      del_feature_logs.map{|x| x.deactivate_feature(@enrolment.course)} if is_del_feature_log
    end
    flash[:notice] = 'Student feature is successfully removed'
    render js: "window.location = '#{edit_user_enrolment_path(@student, @enrolment)}'"
  end

  def create_new_feature_log(pvfp, new_qty)
    @order = Order.create(user_id: @student.id, creator_id: current_user.id, status: :paid,
                          purchase_method: :direct_deposit)
    initial_cost = pvfp.price ||= 0
    master_feature = pvfp.master_feature
    feature_log = pvfp.enrolment_feature_log(@student.id, @enrolment.id, new_qty)
    is_private_tutor = feature_log.master_feature.private_tutoring? && feature_log.user.private_tutor_enrolment(feature_log.course).present?
    if is_private_tutor
      feature_log = pvfp.enrolment_feature_log(@student.id, @enrolment.id, pvfp.qty)
    end
    feature_log.create_purchase_item(initial_cost: initial_cost, user_id: @student.id,purchase_description: master_feature.title,order_id: @order.id)
    if @order.contains_full_course?
      @order.remove_purchase_items

      redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
    else
      @order.complete_purchase(@enrolment.course, nil, true)
    end

    if is_private_tutor
      return false
    else
      return true
    end
  end

  def transfer_by
    @enrolment = Enrolment.find(params[:id])
    authorize(@enrolment)
    (@filterrific = initialize_filterrific(
        @courses,
        params[:filterrific],
        select_options: {
            with_city: Course.options_for_city,
            with_pv: ProductVersion.all.map{|p| [p.name, p.id]}.sort_by { |name, id| name },
            by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ))
  end

  def transfer_course
    @old_enrolment = Enrolment.find(params[:enrolment_id])
    @enrolment = @student.enrolments.where(course_id: @course.id).first

    @enrolment = Enrolment.create(course_id: @course.id, state: Enrolment.states['Transferred']) if @enrolment.blank?
    authorize @enrolment
    if @old_enrolment.present? && @enrolment.valid?
      @order = Order.create(user_id: @student.id, creator_id: current_user.id, status: :ongoing,
                            purchase_method: :direct_deposit)
      @enrolment.create_purchase_item(
        initial_cost: @course.price, user_id: @student.id,
        purchase_description: "#{@course.product_version.name} #{@course.product_version.type}",
        order_id: @order.id
      )

      if @order.contains_full_course?
        @order.remove_purchase_items

        redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
      else
        @order.update(status: %s[free_trial free_study_guide].include?(@course.product_version&.course_type) ? :free : :paid)
        @order.complete_purchase(@course, @old_enrolment)
      end
      @old_enrolment.unenrol
      @course.update_attribute(:is_active, nil)

      redirect_to(edit_user_path(@student), notice: 'Student enroled Successfully')
    else
      redirect_to(:back, notice: @enrolment.errors.full_messages.join(', ')) && return
    end
  end

  def custom_enrol
    pv = @course.product_version
    user_course_enrolments = current_user.enrolments.where(course_id: @course.id)
    @enrolment = user_course_enrolments.first || Enrolment.create(course_id: @course.id)
    authorize(@enrolment)
    if pv.present? && pv.archived?
      @enrolment.destroy
      flash[:error] = 'Cannot purchase course since Product Version is archived. Please contact support team if any updates required.'
      redirect_to gamsat_path
    else
      if params[:custom_pvfps].present? && params[:custom_pvfps][:pvfp_ids].present?
        pvfps = @course.product_version_feature_prices.where(id: params[:custom_pvfps][:pvfp_ids])
        price = 0
        shipping_cost = 0
        pvfps.each do |pvfp|
          shipping_cost = current_user.textbook_shipping_cost if pvfp.master_feature.hardcopy?
          price += pvfp.price
          pvfp.feature_logs.create(enrolment_id: @enrolment.id, qty: pvfp.qty, description: 'custom purchase')
        end
        custom_course_order = current_user.orders
                                          .reload
                                          .includes(:purchase_items)
                                          .where("status = 6 AND purchase_items.purchase_description ILIKE '%custom%'")
                                          .references(:purchase_items).first

        @order = user_course_enrolments.present? && custom_course_order.present? ? custom_course_order : current_user.reload.validate_order
        @enrolment.create_purchase_item(
          initial_cost: price,
          shipping_cost: shipping_cost,
          user_id: current_user.id,
          purchase_description: @course.name,
          order_id: @order.id
        )
        CoursesMailer.course_full_alert(@course).deliver_later if @course.full_alert? && ENV['EMAIL_CONFIRMABLE'] != "false"
        view_type = AdminControl.find_by(name: 'Signup view')
        if view_type.present? && view_type.new_view && current_user.address.present?
          redirect_to course_details_user_path(current_user)
        elsif view_type.present? && view_type.new_view
          redirect_to update_contact_user_path(current_user)
        else
          redirect_to(@order, notice: 'Item added to cart')
        end
      else
        @order = Order.create(user_id: current_user.id, creator_id: current_user.id, status: :paid,
                                  purchase_method: :direct_deposit)
            @enrolment.create_purchase_item(
              initial_cost: @course.price, user_id: current_user.id,
              shipping_cost: 0,
              purchase_description: @course.product_version.name + ' ' +
                @course.product_version.type,
              order_id: @order.id
            )

            if @order.contains_full_course?
              @order.remove_purchase_items

              redirect_to(dashboard_home_path, alert: "The course you are trying to purchase is currently full. Please enroll in another course") && return
            else
              @order.complete_purchase
              redirect_to(dashboard_home_path, notice: 'Custom Course Bought') && return
            end
      end
    end
  end

  private
  def set_course
    @course = Course.friendly.find(params[:course_id] || params[:enrolment][:course_id])
  end

  def set_student
    @student = User.friendly.find(params[:user_id])
  end

  def set_enrolment
    @enrolment = @student.enrolments.find(params[:id])
    authorize @enrolment
  end

  def set_features
    @features = @course.product_version.master_features
  end

  def set_active_courses
    @courses = Course.active_courses.order(:name)
  end

  def enrolment_params
    params.require(:enrolment).permit(:course_id, :paypal_payment,
                                      :paypal_token, :promo, :paid_at,
                                      :subtotal, :gst, :paypal_fee,
                                      :banktrans, :student_id,
                                      :course_id)
  end

  def redirect_url(payment)
    payment.links.find { |v| v.method == 'REDIRECT' }.href
  end

  def ensure_student_course_enrolment
    error = "Student is already enrolled for this course" if @student.course_enroled?(@course.id)
    redirect_back(fallback_location: dashboard_home_path, alert: error) and return if error.present?
  end

  def ensure_course_is_not_enrolled
    error = nil
    if params[:trial] == 'true'
      error = case
              when !@course.trial_enabled?
                "This course is not available for trial"
              when !@course.trial_enabled?
                "This course is not available for trial"
              when current_user.course_enroled?(@course.id)
                "You are already enrolled for this free trial course"
              when current_user.enrolments.where(trial: false).present?
                "You are already enrolled for a course. You can't take new trial"
              when current_user.trial_enrolment.present?
                "You are already enrolled for another free trial course"
            end
    end
    redirect_to(:back, alert: error) and return if error.present?
  end

  def ensure_course_is_not_quick_enrolled
    error = nil
    if params[:trial] == 'true' && current_user
      error = case
                when !@course.trial_enabled?
                  "This course is not available for trial"
                when current_user.course_enroled?(@course.id)
                  "You are already enrolled for this free trial course"
                when current_user.enrolments.where(trial: false).present?
                  "You are already enrolled for a course. You can't take new trial"
                when current_user.trial_enrolment.present?
                  "You are already enrolled for another free trial course"
              end
    end
    redirect_to(:back, alert: error) and return if error.present?
  end

  def verify_purchased_course
    if current_user.present? && current_user.courses.exists?(@course.id)
      if params[:action] == 'enrol' && !(@course.trial_enabled?) && !(@course.price <= 0.1)
        redirect_to_last_order_step
      else
        order = current_user.reload.validate_order_last
        redirect_to order_path(order, payment_page: true)
      end
      # order = current_user.orders.last
      # redirect_to order_path(order, payment_page: true)
    elsif @course.city == "Other" && current_user.courses.active_courses.pluck(:product_version_id).include?(@course.product_version_id)
      order = current_user.reload.validate_order_last
      redirect_to order_path(order, payment_page: true)
    end
  end

  def redirect_to_last_order_step
    if current_user.payment_flow_step.present? && (current_user.payment_flow_step.include? 'orders')
      order = current_user.reload.validate_order
      redirect_to order_path(order, payment_page: true)
    else
      redirect_to current_user.payment_flow_step and return if request.path != current_user.payment_flow_step
    end
  end

  def verify_course_for_user_city
    courses = Course.where(product_version_id: @course.product_version_id, city: Course::CITIES[current_user.state.to_sym]).includes(:lessons) if current_user.state.present?
    take_course_path = @course.product_version.fetch_show_path(true, @course.id, params[:custom_pvfps])
    return if params[:allow_purchase]
    if courses.blank?
      @different_course = true
      redirect_to(take_course_path) and return
    elsif !courses.pluck(:id).include? @course.id
      @different_course = true
      redirect_to(take_course_path) and return
    end
  end

  def generate_shipping_cost
    shipping_cost = 0
    if @course.has_hardcopy_feature
      location = current_user.country
      shipping = Shipping.find_by(country: location)
      shipping_cost = shipping.shipping_amount if shipping
    end
    @shipping_cost = shipping_cost
  end
end
