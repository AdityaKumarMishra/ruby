class ApplicationService
  include CanCan::ControllerAdditions
  include Pundit

  def initialize(user_id)
    @current_user = User.find_by(id: user_id)
  end

  def get_announcement_object(name)
    announcement = Announcement.find_by(name: name)
    return announcement
  end

  def get_announcement_for_dashboard
    announcement = nil
    if @current_user.present? && @current_user.active_course.present?
      type = @current_user.active_course.product_version.type
      if type == 'HscReady' || type == 'VceReady'
        f_name = current_user.active_course.name.include?('Math') ? "#{type}Math" : "#{type}English"
        name = f_name + '-dashboard'
      else
        name = type + '-dashboard'
      end
      announcement = Announcement.find_by(name: name, category: 'Dashboardpage')
    end
    return announcement
  end

  def exam_mcqs(mcqs, mcq_stems)
    tag = nil
    tag = Tag.find_by(id: @filterrific_params[:with_tag_id]) if @filterrific_params[:with_tag_id].present?
    if tag.present?
      tag_ids =[]
          tag.self_and_descendants.each do |t|
            tag_ids << t.self_and_descendants_ids
          end
    end

    exam_select = @filterrific_params[:with_exam_id].present? ? @filterrific_params[:with_exam_id] : "All - Duplicates Not Counted"

    mcqs = if @filterrific_params[:with_status] == "0"
      mcqs.joins(mcq_stem: [section_items: :section]).joins("INNER JOIN online_exams on online_exams.id = sections.sectionable_id ").where("online_exams.published = true AND mcq_stems.published = true")
    elsif @filterrific_params[:with_status] == "1"
      old_mcqs = mcqs.joins(:mcq_stem, [section_items: :section]).joins("INNER JOIN online_exams on online_exams.id = sections.sectionable_id ").where("online_exams.published = true AND mcq_stems.published = true")
      mcqs.joins(mcq_stem: [section_items: :section]).joins("INNER JOIN online_exams on online_exams.id = sections.sectionable_id").where("online_exams.published = false AND mcqs.id NOT IN (?)", old_mcqs.pluck(:id).uniq)
    else
      mcqs.joins(mcq_stem: [section_items: :section]).joins("INNER JOIN online_exams on online_exams.id = sections.sectionable_id")
    end

    mcqs = mcqs.joins(:section_items).distinct.online_exam_mcq(exam_select)
    mcqs = mcqs.includes(:tagging).where(taggings: { tag_id: tag_ids.flatten.uniq }) if tag.present?
    [mcqs.distinct, mcq_stems.where(id: mcqs.pluck(:mcq_stem_id).uniq)]
  end

  def set_custom_course(current_course)
    if current_course
      # return if !current_course.trial_enabled && !current_course.expired?
      return if !current_course.customable?
      city = if @current_user.address.present? && @current_user.address.city.present?
        @current_user.address.city
      else
        "Other"
      end
      @user_custom_course = @current_user.courses.includes(:product_version).where(product_versions: {course_type: ProductVersion::course_types['custom']}, city: Course.cities[city]).first
      return if @user_custom_course.present?
      unless @user_custom_course.present?
        custom_course = Course.includes(:product_version).where(product_versions: {type: current_course.product_version.type, course_type: ProductVersion::course_types['custom']}, city: Course.cities[city]).where('expiry_date >= ?', Time.zone.now.beginning_of_day).order('courses.id DESC').select{|p| !p.course_full?}.first
      end
      return unless custom_course.present?
      enrolment = Enrolment.create(course_id: custom_course.id)
      order = Order.create(user_id: @current_user.id, creator_id: @current_user.id, status: :registered, purchase_method: :direct_deposit)
      if current_course.customable
        enrolment.create_purchase_item(initial_cost:0, user_id: @current_user.id, shipping_cost: 0, purchase_description: "Custom course for Free trail #{current_course.try(:id)}", order_id: order.id)
        enrolment.update(trial: true, trial_expiry: Time.zone.now + current_course.trial_period_days.days)
      else
        enrolment.create_purchase_item(initial_cost:0, user_id: @current_user.id, shipping_cost: 0, purchase_description: "Custom course for Expired course #{current_course.try(:id)}", order_id: order.id)
      end
      custom_course.product_version.product_version_feature_prices.where(is_additional: false).each do |pf|
        acquired = pf.is_default ? DateTime.now : nil
        fe = pf.feature_logs.create(acquired: acquired, enrolment_id: enrolment.id, qty: pf.qty)
      end
      @user_custom_course = custom_course
      return @user_custom_course
    end
  end
end
