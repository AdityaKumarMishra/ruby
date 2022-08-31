class FeatureLogsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]
  before_action :set_feature_log, only: [:show, :destroy, :update]
  before_action :set_shipping_cost, only: [:add_to_cart]
  before_action :set_custom_course_purchase_addons_for_free_trail, only: [:index, :add_to_cart, :purchase_mcqs]
  layout 'layouts/student_page'

  def index
    course_type = ProductVersion.course_types[current_course.try(:product_version).try(:course_type)]
    @enrolment_ids = current_user.enrolments.pluck(:id)
    @selected_enrolment = fetch_selected_enrolment

    @in_cart = ProductVersionFeaturePrice.includes(
      feature_logs: [:enrolment, purchase_item: [:order]]
    ).where('orders.status = ? AND orders.user_id = ? AND feature_logs.enrolment_id IN (?)', 0,
            current_user.id, [@selected_enrolment]
           ).order(:qty).references(:enrolments)
    @in_cart_essays = @in_cart.includes(feature_logs: [:master_feature]).where("master_features.name like '%EssayFeature%'").map(&:qty).sum
    product_version_ids = @user_custom_course.present? ? @user_custom_course.product_version.id : current_course.present? ? current_course.product_version.id : []
    @pending_confirmation = ProductVersionFeaturePrice.includes(
      feature_logs: [:enrolment, purchase_item: [:order]]
    ).where('orders.status = ? AND orders.user_id = ? AND feature_logs.enrolment_id IN (?)', 1,
            current_user.id, [@selected_enrolment]
           ).order(:qty).references(:enrolments)
    #------------------GRAD-2796----------------------
    expection_pvfp = []
    if current_course.present?
      if current_course.product_version_id == 9 || current_course.product_version_id == 10
        expection_feature_logs = current_user.feature_logs.select{|f| f.product_version_feature_price.master_feature.title == "Essays" && f.enrolment_id == @selected_enrolment }
        expection_pvfp << expection_feature_logs.first.product_version_feature_price if expection_feature_logs.present?
      end
      if current_course.product_version_id == 10
        expection_feature_logs = current_user.feature_logs.select{|f| f.product_version_feature_price.master_feature.title == "Book Tutor" && f.enrolment_id == @selected_enrolment }
        expection_pvfp << expection_feature_logs.first.product_version_feature_price if expection_feature_logs.present?
      end
    end
    #------------------GRAD-2796----------------------
    all_inactive_features = ProductVersionFeaturePrice.includes(:feature_logs).where(feature_logs: {enrolment_id: [@selected_enrolment]}, product_version_id: product_version_ids)
    all_inactives = all_inactive_features.where(feature_logs: {acquired: nil}, is_default: false).order(:qty)
    inactive_but_active = all_inactive_features.where(is_default: false).where.not(feature_logs: {acquired: nil})
    active_but_inactive = all_inactive_features.where(feature_logs: {acquired: nil}, is_default: true)
    @inactive = all_inactives + active_but_inactive - inactive_but_active - @pending_confirmation - @in_cart
    #------------------GRAD-2796----------------------
    @inactive << expection_pvfp if expection_pvfp.present?
    #------------------GRAD-2796----------------------
    p_type = current_course.try(:product_version).try(:type)
    if p_type == 'UmatReady'
      tag = Tag.find_by(name: 'UM UMAT')
    else
      tag = Tag.find_by(name: 'GM GAMSAT')
    end
    # Adding partially added features
    partial_ids = []
    current_user.active_enrolment_features.where.not(qty: nil).group_by(&:master_feature).each do |master_feature, feature_logs|
      next if master_feature.private_tutoring? || master_feature.essay?
      if master_feature.mcq_feature?
        @mcq_purchase_qty = feature_logs.map(&:qty).sum
      end
      if master_feature.exam_feature?
        @exam_purchase_qty = feature_logs.map(&:qty).sum
        course_tag_ids = current_user.current_course_tags.collect{|t| t.id}
        @online_exam_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids }).order("online_exams.title")
        added_feature_log_exams = current_user.online_exam_feature.where.not(exam_name: nil)
        default_feature_log_exams = current_user.online_exam_feature.where(exam_name: nil)
        added_exams = OnlineExam.where(title: added_feature_log_exams.pluck(:exam_name))
        user_exam_attempt_ids = @online_exam_attempts.pluck(:assessable_id)
        qty = default_feature_log_exams.sum(:qty)
        qty = @exam_purchase_qty if qty == 0
        @online_exam_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids }).order("online_exams.title")
        user_exam_attempt_ids = @online_exam_attempts.pluck(:assessable_id)
        if qty.present? && qty >= @online_exam_attempts.count
          @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).order(:position).limit(qty - @online_exam_attempts.count)
        else
          @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).order(:position)
        end
        @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).where(position: nil) + @online_exams + added_exams
        @remaining_online_exams = policy_scope(OnlineExam).where.not(id: @online_exams.map(&:id) + @online_exam_attempts.pluck(:assessable_id)).order(:position)
        @remaining_online_exams_count = @remaining_online_exams.count
        @in_cart_exam_qty = 0
      end
      if master_feature.max_qty.present?
        if feature_logs.map(&:qty).sum < master_feature.max_qty
          partial_ids << feature_logs.map(&:product_version_feature_price_id) unless current_user.active_enrolment_features.where(product_version_feature_price_id: feature_logs.first.product_version_feature_price_id, qty: nil).present?
        end
      else
        qty = master_feature.update_maximum_qty(tag)
        if feature_logs.map(&:qty).sum < qty
          partial_ids << feature_logs.map(&:product_version_feature_price_id)
        end
      end
    end

    @essays_responses_count = current_user.essay_responses.includes(:course, :essay, essay_tutor_response: [staff_profile: [:staff]]).where(courses: { id: Enrolment.find(@selected_enrolment).course_id },assessment_attempt_id: nil).order('essays.position').count

    @mcq_purchase_qty = 0 if @mcq_purchase_qty.nil?
    if @exam_purchase_qty.nil?
      @exam_purchase_qty = 0
      course_tag_ids = current_user.current_course_tags.collect{|t| t.id}
      @online_exam_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids }).order("online_exams.title")
      user_exam_attempt_ids = @online_exam_attempts.pluck(:assessable_id)
      if @exam_purchase_qty.present? && @exam_purchase_qty >= @online_exam_attempts.count
        @online_exams = OnlineExam.by_product_line("Gamsat").where.not(id: user_exam_attempt_ids).order(:position).limit(@exam_purchase_qty - @online_exam_attempts.count)
      else
        @online_exams = OnlineExam.by_product_line("Gamsat").where.not(id: user_exam_attempt_ids).order(:position)
      end
      @online_exams = OnlineExam.by_product_line("Gamsat").where.not(id: user_exam_attempt_ids).where(position: nil) + @online_exams
      expection = ["Diagnostic Assessment ","GAMSAT Exam 9"]
      @remaining_online_exams = OnlineExam.by_product_line("Gamsat").where(published: true).where.not(id: @online_exams.map(&:id) + @online_exam_attempts.pluck(:assessable_id), title: expection ).order(:position)
      @remaining_online_exams_count = @remaining_online_exams.count
      @in_cart_exam_qty = 0
    end
    non_partial_ids = @in_cart.includes(:master_feature).where('master_features.name NOT LIKE (?) AND master_features.name NOT LIKE (?)', '%ExamFeature%', '%McqFeature%').ids
    partial_ids = partial_ids.flatten - non_partial_ids
    # partial_features = ProductVersionFeaturePrice.where(id: partial_ids)
    partial_features = ProductVersionFeaturePrice.includes(:feature_logs).where(feature_logs: {enrolment_id: [@selected_enrolment]}, product_version_id: product_version_ids, id: partial_ids)
    @inactive = (@inactive + partial_features).uniq if partial_features.present?
    if params[:feature_type].present?
      redirect_to(dashboard_no_access_path(feature_type: params[:feature_type], inactive: @inactive))
    end
  end

  def add_to_cart
    pvfp = ProductVersionFeaturePrice.find(params[:id])

    master_feature = pvfp.master_feature
    @enrolment_ids = current_user.enrolments.pluck(:id)
    @selected_enrolment = fetch_selected_enrolment
    pvfp1 = pvfp

    if (master_feature.private_tutoring? || master_feature.essay? || master_feature.exam_feature?)
      pvfp = ProductVersionFeaturePrice.create!(pvfp1.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :price, :qty, :subtype_change_date, :is_additional).merge(qty: (params[:quantity] || 1).to_i, price: (pvfp1.price * (params[:quantity] || 1).to_i), is_additional: true))
      pvfp.tags << pvfp1.tags
      pvfp.save!
    else
      pvfp = pvfp1
    end

    enrolment_id = @selected_enrolment
    feature_log = pvfp.enrolment_feature_log(current_user.id, enrolment_id, params[:quantity])
    authorize(feature_log)
    order = current_user.validate_order

    qty = pvfp.qty
    if params[:mcq_range_price].present? && params[:mcq_range_qty].present?
      qty = params[:mcq_range_qty]
      if feature_log.purchase_item.present?
        feature_log.update(qty: params[:mcq_range_qty], description: "#{params[:mcq_range_qty]} added by range slider")
      else
        feature_log = pvfp.feature_logs.create(acquired: nil, enrolment_id: enrolment_id, qty: params[:mcq_range_qty], description: "#{params[:mcq_range_qty]} added by range slider")
      end
      initial_cost = params[:mcq_range_price]
    else
      initial_cost = pvfp.price ||= 0
    end

    if params[:exam_range_price].present? && params[:exam_range_qty].present?
      qty = params[:exam_range_qty]
      if feature_log.purchase_item.present?
        feature_log.update(qty: params[:exam_range_qty], description: "#{params[:exam_range_qty]} added by range slider")
      else
        feature_log = pvfp.feature_logs.create(acquired: nil, enrolment_id: enrolment_id, qty: params[:exam_range_qty], description: "#{params[:exam_range_qty]} added by range slider", exam_name: params[:exam_name])
      end
      initial_cost = params[:exam_range_price]
    else
      initial_cost = pvfp.price ||= 0
    end
    course_type = ProductVersion.course_types[current_course.try(:product_version).try(:course_type)]

    feature_log.create_purchase_item(initial_cost: initial_cost,
                                     user_id: current_user.id,
                                     shipping_cost: @shipping_cost,
                                     purchase_description: "#{qty.present? ? qty.to_s + ' ' : ''}#{master_feature.title}",
                                     order_id: order.id
                                    )

    @in_cart = ProductVersionFeaturePrice.includes(
      feature_logs: [:enrolment, purchase_item: [:order]]
    ).where('orders.status = ? AND orders.user_id = ? AND feature_logs.enrolment_id IN (?)', 0,
            current_user.id, [@selected_enrolment]
           ).order(:qty).references(:enrolments)

    @in_cart_essays = @in_cart.includes(feature_logs: [:master_feature]).where("master_features.name like '%EssayFeature%'").map(&:qty).sum
    product_version_ids = @user_custom_course.present? ? @user_custom_course.product_version.id : current_course.present? ? current_course.product_version.id : []

    @pending_confirmation = ProductVersionFeaturePrice.includes(
      feature_logs: [:enrolment, purchase_item: [:order]]
    ).where('orders.status = ? AND orders.user_id = ? AND feature_logs.enrolment_id IN (?)', 1,
            current_user.id, [@selected_enrolment]
           ).order(:qty).references(:enrolments)

    all_inactive_features = ProductVersionFeaturePrice.includes(:feature_logs).where(feature_logs: {enrolment_id: [@selected_enrolment]}, product_version_id: product_version_ids)
    all_inactives = all_inactive_features.where(feature_logs: {acquired: nil}, is_default: false).order(:qty)
    inactive_but_active = all_inactive_features.where(is_default: false).where.not(feature_logs: {acquired: nil})
    active_but_inactive = all_inactive_features.where(feature_logs: {acquired: nil}, is_default: true)

    @inactive = all_inactives + active_but_inactive - inactive_but_active - @pending_confirmation - @in_cart

    p_type = current_course.product_version.try(:type)
    if p_type == 'UmatReady'
      tag = Tag.find_by(name: 'UM UMAT')
    else
      tag = Tag.find_by(name: 'GM GAMSAT')
    end
    # Adding partially added features
    partial_ids = []
    current_user.active_enrolment_features.where.not(qty: nil).group_by(&:master_feature).each do |master_feature, feature_logs|
      next if master_feature.private_tutoring? || master_feature.essay?
      if master_feature.mcq_feature?
        @mcq_purchase_qty = feature_logs.map(&:qty).sum
      end
      if master_feature.exam_feature?
        @exam_purchase_qty = feature_logs.map(&:qty).sum
        course_tag_ids = current_user.current_course_tags.collect{|t| t.id}
        @online_exam_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids }).order("online_exams.title")
        added_feature_log_exams = current_user.online_exam_feature.where.not(exam_name: nil)
        default_feature_log_exams = current_user.online_exam_feature.where(exam_name: nil)
        added_exams = OnlineExam.where(title: added_feature_log_exams.pluck(:exam_name))
        user_exam_attempt_ids = @online_exam_attempts.pluck(:assessable_id)
        qty = default_feature_log_exams.sum(:qty)
        qty = @exam_purchase_qty if qty == 0
        @online_exam_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids }).order("online_exams.title")
        user_exam_attempt_ids = @online_exam_attempts.pluck(:assessable_id)
        if qty.present? && qty >= @online_exam_attempts.count
          @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).order(:position).limit(qty - @online_exam_attempts.count)
        else
          @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).order(:position)
        end
        @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).where(position: nil) + @online_exams + added_exams
        @remaining_online_exams = policy_scope(OnlineExam).where.not(id: @online_exams.map(&:id) + @online_exam_attempts.pluck(:assessable_id)).order(:position)
        @remaining_online_exams_count = @remaining_online_exams.count
        @in_cart_exam_qty = params[:exam_range_qty].to_i
      end
      if master_feature.max_qty.present?
        if feature_logs.map(&:qty).sum < master_feature.max_qty
          partial_ids << feature_logs.map(&:product_version_feature_price_id)
        end
      else
        qty = master_feature.update_maximum_qty(tag)
        if feature_logs.map(&:qty).sum < qty
          partial_ids << feature_logs.map(&:product_version_feature_price_id)
        end
      end
    end

    @essays_responses_count = current_user.essay_responses.includes(:course, :essay, essay_tutor_response: [staff_profile: [:staff]]).where(courses: { id: Enrolment.find(@selected_enrolment).course_id },assessment_attempt_id: nil).order('essays.position').count

    non_partial_ids = @in_cart.includes(:master_feature).where('master_features.name NOT LIKE (?) AND master_features.name NOT LIKE (?)', '%ExamFeature%', '%McqFeature%').ids
    partial_ids = partial_ids.flatten - non_partial_ids
    partial_features = ProductVersionFeaturePrice.where(id: partial_ids)
    @inactive = (@inactive + partial_features).uniq if partial_features.present?

    @order = current_user.validate_order
    if @exam_purchase_qty.nil?
      @exam_purchase_qty = 0
      course_tag_ids = current_user.current_course_tags.collect{|t| t.id}
      @online_exam_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids }).order("online_exams.title")
      user_exam_attempt_ids = @online_exam_attempts.pluck(:assessable_id)
      if @exam_purchase_qty.present? && @exam_purchase_qty >= @online_exam_attempts.count
        @online_exams = OnlineExam.by_product_line("Gamsat").where.not(id: user_exam_attempt_ids).order(:position).limit(@exam_purchase_qty - @online_exam_attempts.count)
      else
        @online_exams = OnlineExam.by_product_line("Gamsat").where.not(id: user_exam_attempt_ids).order(:position)
      end
      @online_exams = OnlineExam.by_product_line("Gamsat").where.not(id: user_exam_attempt_ids).where(position: nil) + @online_exams
      expection = ["Diagnostic Assessment ","GAMSAT Exam 9"]
      @remaining_online_exams = OnlineExam.by_product_line("Gamsat").where(published: true).where.not(id: @online_exams.map(&:id) + @online_exam_attempts.pluck(:assessable_id), title: expection ).order(:position)
      @remaining_online_exams_count = @remaining_online_exams.count
      @in_cart_exam_qty = 0
    end

    @mcq_purchase_qty = 0 if @mcq_purchase_qty.nil?
    if params[:move_to_order].present?
      view_type = AdminControl.find_by(name: 'Signup view')
      if view_type.present? && view_type.new_view && current_user.has_free_trial_only? && current_user.address.blank?
        render :js => "window.location = '/users/#{current_user.id}/update_contact'"
      else
        render :js => "window.location = '/orders/#{@order.id}'"
      end

    else
      respond_to do |format|
        format.html { redirect_to(feature_logs_path, notice: 'Item added to cart') && return }

        format.js
      end
    end
  end

  def destroy
    @feature_log.destroy
    redirect_to feature_logs_path, notice: 'cart is empty'
  end

  def show
    authorize(@feature_log)
  end

  def find_feature_price
    @type = params[:type]
    @student = User.find_by(id:  params[:student_id]) if @type.present?

    if params[:qty].present?
      pvp = ProductVersionFeaturePrice.find(params[:id])
      @pvfp = ProductVersionFeaturePrice.where(master_feature_id: pvp.master_feature_id, product_version_id: pvp.product_version_id, qty: params[:qty].to_i).first
      @pvfp = ProductVersionFeaturePrice.create!(pvp.attributes.symbolize_keys.except(:id, :qty, :created_at, :updated_at, :price).merge!(qty: params[:qty], price: (pvp.price * params[:qty].to_i))) if @pvfp.blank?
    else
      @pvfp = ProductVersionFeaturePrice.find(params[:id])
    end

    @enrolment = Enrolment.find_by(id: params[:enrol_id])
  end

  def find_pv_price
    @pvfp = ProductVersionFeaturePrice.find(params[:id])
  end


  def purchase_mcqs
     enrol_ids = if @user_custom_course.present? && (current_course.trial_enabled || current_course.expired?)
                      Course.find(@user_custom_course.id).enrolments.includes(:order).where('orders.user_id =?', current_user.id).references(:orders).pluck(:id)
                    elsif current_course
                      current_course.enrolments.includes(:order).where('orders.user_id =?', current_user.id).references(:orders).pluck(:id)
                    else
                      current_user.enrolments.pluck(:id)
                    end

    product_version_ids = @user_custom_course.present? ? @user_custom_course.product_version.id : current_course.present? ? current_course.product_version.id : []
    inactive = ProductVersionFeaturePrice.includes(:feature_logs).where('feature_logs.acquired IS ? AND feature_logs.enrolment_id IN (?)', nil, enrol_ids ).where(product_version_id: product_version_ids, is_default: false).references(:feature_logs)
    pvfp = inactive.find{|s| s.master_feature.mcq_feature? }
    if pvfp.present?
      master_feature = pvfp.master_feature
      feature_log = pvfp.enrolment_feature_log(current_user.id, enrol_ids.first)
      authorize(feature_log)
      order = current_user.validate_order
      feature_log.update(qty: 500, description: "500 mcq added by range slider")
      mcq_course = current_user.active_courses.includes(:product_version).find_by(product_versions: { course_type: 0, type: current_course.product_version.type })
      free_pvfp = mcq_course.product_version.product_version_feature_prices.find{|s| s.master_feature.mcq_feature? }
      initial_cost = (free_pvfp.price / free_pvfp.qty) * 500 if free_pvfp.present? && free_pvfp.qty.present?
      feature_log.create_purchase_item(initial_cost: initial_cost,
                                       user_id: current_user.id,
                                       shipping_cost: 0,
                                       purchase_description: master_feature.title,
                                       order_id: order.id
                                      )
      view_type = AdminControl.find_by(name: 'Signup view')
      if view_type.present? && view_type.new_view && current_user.has_free_trial_only?
        redirect_to  update_contact_user_path(current_user)
      else
        redirect_to order
      end

    else
      redirect_to dashboard_home_path
    end
  end

  def update
    if params[:exam_id].present?
      # adding extra exam to student
      qty = @feature_log.acquired ? (@feature_log.qty.to_i + 1) : 1
      acquired = @feature_log.acquired.present? ? @feature_log.acquired : Time.zone.now
      @feature_log.update(qty: qty, acquired: acquired)
      msg = 'Exam added successfully!'
    elsif params[:add_essay_id].present?
      qty = @feature_log.acquired ? (@feature_log.qty.to_i + params[:add_essay_id].size) : params[:add_essay_id].size
      acquired = @feature_log.acquired.present? ? @feature_log.acquired : Time.zone.now
      @feature_log.update(qty: qty, acquired: acquired)
      params[:add_essay_id].each do |add_essay_id|
        @feature_log.user
                    .essay_responses
                    .find_or_create_by(user_id: @feature_log.user.id,
                                       essay_id: add_essay_id,
                                       activation_date: Date.today.to_s,
                                       expiry_date: @feature_log.enrolment.course.expiry_date.to_s,
                                       course_id: @feature_log.enrolment.course_id)
      end
      create_essay_order(@feature_log, params[:add_essay_id].size)
      msg = 'Essay added successfully'
    elsif params[:remove_essay_id].present?
      qty = @feature_log.acquired ? (@feature_log.qty.to_i - params[:remove_essay_id].size) : params[:remove_essay_id].size
      acquired = @feature_log.acquired.present? ? @feature_log.acquired : Time.zone.now
      @feature_log.update(qty: qty, acquired: acquired)
      @feature_log.user.essay_responses.where(essay_id: params[:remove_essay_id]).map(&:destroy)
      create_essay_order(@feature_log, (-1 * params[:remove_essay_id].size))
      msg = 'Essay removed successfully'
    else
      qty = @feature_log.qty.to_i + (params[:feature_log][:qty].to_i)
      @feature_log.update(qty: qty)
      msg = 'Qty Added successfully!'
    end
    redirect_to edit_user_enrolment_path(user_id: @feature_log.user.id, id: @feature_log.enrolment_id), notice: msg
  end

  def pvfp_qty_price
    pvfp = ProductVersionFeaturePrice.find(params[:id])
    if pvfp.master_feature.mcq_feature?
      total_price = params[:qty].to_i * 0.1
    else
      unit_price = (pvfp.ten_percent_gst_amount / pvfp.qty)
      total_price = unit_price * params['qty'].to_i
    end
    if params[:course_type] == '1'
      discount_price = nil
    else
      discount = (total_price.to_f * 25) / 100
      discount_price = total_price - discount
    end
    render json: { discount_price: discount_price.to_i, total_price: total_price.to_i, master_feature_id: pvfp.master_feature_id }
  end


  private

  def fetch_selected_enrolment
    if current_user.active_enrolled_courses.count == 1
      courses = current_user.courses.where("name like '%Custom%'")
      if courses.blank?
        courses = current_user.active_courses.pluck(:id)
      else
        courses = courses.pluck(:id)
      end

      @selected_enrolment_obj = current_user.enrolments.where(course_id: courses).first
      @selected_course = Course.find(@selected_enrolment_obj.course_id) if @selected_enrolment_obj.present?
      @selected_enrolment_obj.try(:id)
    else
      @selected_enrolment_obj = current_user.enrolments.where(course_id: current_course.try(:id).to_i).first
      @selected_course = Course.find(@selected_enrolment_obj.course_id) if @selected_enrolment_obj.present?
      @selected_course = current_user.enrolments.last&.course if @selected_course.blank?
      @selected_enrolment_obj.try(:id) || @enrolment_ids.last
    end
  end

  def set_feature_log
    @feature_log = FeatureLog.find(params[:id])
  end

  def create_essay_order(feature_log, size)
    order = Order.create(user_id: feature_log.user.id, creator_id: current_user.id, status: :paid,
                         purchase_method: :direct_deposit)
    initial_cost = 0
    master_feature = feature_log.master_feature
    feature_log.create_purchase_item(
      initial_cost: initial_cost, user_id: feature_log.user.id,
      purchase_description: feature_log.product_version_feature_price.subtype == 'subtype_1' ? "#{size} #{master_feature.title}" : master_feature.title,
      order_id: order.id
    )
    order.complete_purchase(feature_log.enrolment.course, nil, nil, true, false, size)
    feature_log.user.remove_duplicate_essays_if_any(feature_log.enrolment.course)
    # order.customise_email_template_for_master_feature_manual(master_feature)
  end

  def set_shipping_cost
    pvfp = ProductVersionFeaturePrice.find(params[:id])
    master_feature = pvfp.master_feature
    shipping_cost = 0
    if master_feature.hardcopy?
      location = current_user.country
      shipping = Shipping.find_by(country: location)
      shipping_cost = shipping.shipping_amount if shipping
    end
    @shipping_cost = shipping_cost
  end
end
