class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_expired_courses, only: [:book_tutor, :textbooks]
  before_action :check_date_range, only: [:book_tutor]
  before_action :set_custom_course_purchase_addons_for_free_trail, only: [:home]
  layout :resolve_layout
  respond_to :html, :js

  def home
    @only_dd_pending = false
    @only_expired_course = false
    if current_user.student? && !current_user.paid_courses.present? && (current_user.orders.where(status: :ongoing).present? && current_user.orders.where(status: :ongoing).last.purchase_items.present?) && AdminControl.find_by(name: 'Signup view').try(:new_view)
      if  current_user.payment_flow_step.present? && request.path != current_user.payment_flow_step
        redirect_to current_user.payment_flow_step
      else
        redirect_to current_user.orders.where(status: :ongoing).last
      end
    elsif current_user.student? && !current_user.confirmed?
      render layout: 'layouts/student_page'
    elsif current_user.student? && !current_user.questionnaire.present? && (current_user.paid_courses.present? || current_user.orders.pending.present?) && (!current_user.has_free_trial_only? || params[:update_background])
      if (current_user.active_course.present? && current_user.active_course.customable? && !current_user.address.present?)
        redirect_to current_user.payment_flow_step
      else
        @update_background = true
        @user = current_user
        @user.build_questionnaire
        render layout: 'layouts/student_page'
      end
    elsif !current_user.paid_courses.present? && current_user.orders.pending.present?
      @only_dd_pending = true
      render layout: 'layouts/student_page'
    elsif current_user.active_enrolled_courses.blank? && current_user.trial_enrolment.present?
      @only_expired_course = true
    else
      @update_background = false
      @announcement = get_dashboard_announcement
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id) if @announcement.present?
      @last_order = current_user.orders.where(status: Order.statuses[:paid]).last
    end
  end

  def upgrade
    unless current_course&.trial_enabled? || current_user.trial_enrolment
      redirect_to dashboard_home_path
    end
  end

  def calender
    if current_user.student?
      @events_dates = User.events_dates(current_user, current_course)
      @events_not_present = []
      @events_dates.each do |e|
        if (e.to_date < Date.today + 30) && (e.to_date > Date.today)
          @events_not_present << e
        end
      end
      @first_day = @events_dates.select{|e| e.to_date > Date.today}.min()
      @closest_events = User.important_calender_dates(@first_day, current_user, current_course)
      @events_dates = @events_dates.to_json
    end
  end

  def student_enrolments
    @usiversities = University.all
  end

  def book_tutor
    @course = current_course
    if params[:student_id].present?
      @student = User.find_by(id: params[:student_id])
      if params[:course_id].present?
        @course = Course.find_by(id: params[:course_id])
        @student.active_course = @course
      else
        redirect_to reset_exams_user_path(params[:student_id]), error: 'Please select Course' and return
      end
    end
    user = @student.present? ? @student : current_user

    master_feature = current_user.accessible_features.find_by('name LIKE?', '%PrivateTutoringFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    @booked_appointments = user.appointments.active.order(start_time: :asc)
    @time_left = user.private_tutor_time_left - user.appointments.active.where(course_id: @course.id).count
    if user.student?
      @filterrific = initialize_filterrific(
        TutorProfile.includes(tutor: [:address, staff_profile: :tags]).private_tutor,
        filterrific_params,
        select_options: {
          subject_tags: user.current_product_verion_feature_price_tags('PrivateTutoringFeature').map { |t| [t.name, t.id] }
        },
        persistence_id: false
      ) or return
    else
      @filterrific = initialize_filterrific(
        TutorProfile.includes(tutor: [:address, staff_profile: :tags]).private_tutor,
        filterrific_params,
        select_options: {
          subject_tags: current_user.current_product_verion_feature_price_tags('PrivateTutoringFeature').map { |t| [t.name, t.id] }
        },
        persistence_id: false
      ) or return
    end
    tag_ids = Tag.by_product_line(current_user.active_course.product_version.product_line.name)
    @time_slots = @filterrific.find.for_tutor([1,2]).with_tag(tag_ids)
    @time_slots = @time_slots.paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def filtered_tutors
    subject_tag_id = params[:subject_tag].present? ? params[:subject_tag] : nil
    location_id = params[:location].present? ? params[:location] : nil

    if subject_tag_id.present? && location_id.present?
      @options= User.tutor.includes(:tutor_profile, :address, staff_profile: :tags).where("(tutor_profiles.private_tutor=? AND addresses.state=? AND tags.id=?)", true, location_id, subject_tag_id).references(:tutor_profiles, :addresses, :staff_profiles).sort { |a, b| a.full_name <=> b.full_name }
    elsif location_id.present?
      @options= User.tutor.includes(:tutor_profile, :address).where("(tutor_profiles.private_tutor=? AND addresses.state=?)", true, location_id).references(:tutor_profiles, :addresses).sort { |a, b| a.full_name <=> b.full_name }
    elsif subject_tag_id.present?
      @options= User.tutor.includes(:tutor_profile, staff_profile: :tags).where("(tutor_profiles.private_tutor=? AND tags.id=?)", true, subject_tag_id).references(:tutor_profiles, :staff_profiles).sort { |a, b| a.full_name <=> b.full_name }
    else
      @options= User.includes(:tutor_profile).where("role >= ? AND tutor_profiles.private_tutor=?", User.roles[:tutor], true).references(:tutor_profiles).sort { |a, b| a.full_name <=> b.full_name }
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def no_access
    check_background_informaation
    @feature = MasterFeature.find_by(id: params[:feature_type])
    if @feature.present?
      @pvs = ProductVersionFeaturePrice.where(id: params[:inactive], master_feature_id: @feature.id).order('qty')
    else
      @pvs = []
    end
    if @feature.online_mock_exam?
      enrolment = current_user.enrolments.find_by(course_id: current_course.id)
      mock_exam = enrolment.feature_logs.joins(:product_version_feature_price).where("product_version_feature_prices.master_feature_id = ?", params[:feature_type]).first
      if mock_exam.present? && mock_exam.acquired
        redirect_to send(@feature.url)
      end
    end
  end

  def check_background_informaation
    if current_user.student? && !current_user.questionnaire.present?
      current_user.update_feature_access_count
      redirect_to dashboard_home_path(update_background: true) and return if current_user.feature_access_count > 2
    end
  end

  def count_tutor_appointments
    redirect_to root_path and return if current_user.student?
    params[:filterrific] ||= {}
    params[:filterrific] = eval(params[:filterrific]) || {} if params[:filterrific].class == String
    filters = nil
    if params[:with_pay_period].present?
      @selected_date = params[:with_pay_period]
      @from_filter = params[:with_pay_period].split(' - ')[0]
      @to_filter  = params[:with_pay_period].split(' - ')[1]
    else
      if params[:filterrific][:with_start].present? || params[:filterrific][:with_end].present?
        @from_filter = params[:filterrific][:with_start]
        @to_filter = params[:filterrific][:with_end]
        @selected_date = "#{@from_filter} - #{@to_filter}"
      else
        @selected_date = []
        Appointment.pay_periods.each do |ap|
          pay_period_date = ap[0].split(' - ')
          from_date = pay_period_date[0]
          upto_date = pay_period_date[1]
          if from_date.to_date <= Date.today  && Date.today <= upto_date.to_date
            @selected_date << ap
            @from_filter = from_date
            @to_filter  = upto_date
          end
        end
        @selected_date = @selected_date.flatten[0]
      end
    end
    @filterrific = initialize_filterrific(
      AppointmentHour,
      params[:filterrific],
    ) or return
    if params[:reset]
      @filterrific.with_start = nil
      @filterrific.with_end = nil
      @filterrific.tutor = nil
    end

    if (@from_filter.present? || @to_filter.present?) && params[:filter_type] == 'pay_period'
      filters = {with_start: @from_filter, with_end: @to_filter, tutor: params[:filterrific][:tutor]}
    end

    @courses = Course.active_courses
    unless params[:selection] == 'PT Sessions by Student - Unused Sessions'
      filter_with_end_only = { with_end: @to_filter.presence, tutor: params[:filterrific][:tutor] }
      filter_with_end_as_start_only = { with_end: @from_filter.presence, tutor: params[:filterrific][:tutor], not_equal: true }

      @appointment_hours = AppointmentHour.get_filtered_hours_zero(filters || params[:filterrific]).includes(:appointment).where('appointments.course_id IN (?)', @courses.ids).references(:appointment)
      @appointment_hours_with_end = AppointmentHour.get_filtered_hours_created_at(filter_with_end_only).includes(:appointment).where('appointments.course_id IN (?)', @courses.ids).references(:appointment)
      @appointment_hours_with_end_as_start = AppointmentHour.get_filtered_hours_zero(filter_with_end_as_start_only).includes(:appointment).where('appointments.course_id IN (?)', @courses.ids).references(:appointment)
      @ah = @appointment_hours
      @ah_end = @appointments_with_end
      @ah_start = @appointment_hours_with_end_as_start

      if @appointment_hours.present?
        @appointment_hours = @appointment_hours.group_by(&:appointment_id)
        @appointment_hours_with_end = @appointment_hours_with_end.group_by(&:appointment_id)
        @appointment_hours_with_end_as_start = @appointment_hours_with_end_as_start.group_by(&:appointment_id)
        @appointments = Appointment.where(id: @appointment_hours.keys).distinct
        @appointments_with_end = Appointment.where(id: @appointment_hours_with_end.keys).distinct
        @appointments_with_start = Appointment.where(id: @appointment_hours_with_end_as_start.keys).distinct
        tutor_ids = @appointments.pluck(:tutor_id)
        @tuts = current_user.tutor? ? User.where(id: current_user.id) : User.where(id: tutor_ids).distinct.order(:first_name)
        @tutors = @tuts.paginate(page: params[:page], per_page: 20) unless params[:format] == 'xls'
      end
    else
      @courses = @courses.where(city: params[:filterrific][:city]) if params[:filterrific][:city].present?

      @students = User.student.joins(feature_logs: :master_feature).where.not(feature_logs: { acquired: nil }).where(feature_logs: { master_features: { name: 'GamsatPrivateTutoringFeature' } }).order(:first_name).where(enrolments: { course_id: @courses.ids }).distinct
      student_ids = @students.map(&:id).uniq

      @students = @students.with_name(params[:filterrific][:student]) if params[:filterrific][:student].present?

      @appointments = Appointment.where(student_id: student_ids, status: 0, course_id: @courses.ids)
      @appointments = @appointments.created_with_end(@to_filter).to_a if @to_filter.present?
      @students = @students.paginate(page: params[:page], per_page: 20) unless params[:format] == 'xls'
    end

    flash[:alert] = nil
    if params[:selection] == "PT Sessions by Tutor - Student Breakdown"
      @ap_type = "private_tutor"
    elsif params[:selection] == "PT Sessions by Student - Unused Sessions"
      @ap_type = "unbooked_session"
    else
      @ap_type = "all_session"
    end

    @display_date = if params[:with_pay_period].present?
      params[:with_pay_period]
    elsif params[:filterrific][:with_start].present? && params[:filterrific][:with_end].present?
      "#{@from_filter} - #{@to_filter}"
    elsif params[:filterrific][:with_start].present?
      "#{@from_filter} - Present"
    elsif params[:filterrific][:with_end].present?
      "Start - #{@to_filter}"
    else
      "All Available Data"
    end

    file_name = "tutor_appointments_count - #{Date.today}"
    respond_to do |format|
      format.html
      format.js
      format.xls {
        response.headers['Content-Disposition'] = 'attachment; filename="' + file_name + '.xls"'
      }
    end
  end

  def tutor_appointments
    @tutor = User.friendly.find(params[:tutor_id])
    @appointment = @tutor.tutor_profile.tutor_appointments.where(status: 0)
    @appointment_hours = AppointmentHour.where("appointment_id IN (?) AND hours != 0", @appointment.pluck(:id)).includes(:appointment).distinct
    @appointment_hours = @appointment_hours.paginate(:page => params[:page] || 1, per_page: 20)
  end

  def staff_answered_questions
    if params[:filterrific].present? && params[:filterrific][:answerer_filter].present?
      @tutors = []
      @tutors << User.find(params[:filterrific][:answerer_filter])
    else
      @tutors = User.where('role >= ? AND first_name is NOT ?', User.roles[:tutor], nil).order(:first_name).paginate(:page => params[:page], per_page: 20)
    end

    @filterrific = initialize_filterrific(
      Ticket,
      params[:filterrific],
        select_options: {
          answerer_filter: User.where('role >= ? AND first_name is NOT ?', User.roles[:tutor], nil)
                             .sort { |a, b| a.full_name <=> b.full_name }
                             .map { |u| [u.full_name, u.id] }
        }
    ) || return



    @tickets = @filterrific.find

    respond_to do |format|
      format.html
      format.js
    end
  end

  def time_remaining
    render :partial => "exercises/status"
  end

  def unresolved_issues
    if current_user.student?
      general_tags= Tag.where("id IN (?)", [261,262,338,343] )
      student_public_tags = current_course.present? ? Tag.where('is_public=? AND name like ?', true, "%#{current_course.name.split(/-|:/).first}%") : Tag.none
      student_tags = current_user.current_course_tags+student_public_tags+general_tags

      tags= student_tags.sort_by(&:name).map { |t| [t.name, t.id] }
      filterrific_student = Ticket.includes(:ticket_answers).where(asker_id: current_user.id).order(Arel.sql("tickets.created_at DESC"))
      default_filter_params = {sorted_by: 'created_at', resolved_filter: 1, with_start_filter: Date.today-7, with_end_filter: Date.today + 2}
    else
      tags= Tag.all.order(:name).map { |t| [t.name, t.id] }
      filterrific_student = Ticket.includes(:ticket_answers).order(Arel.sql("tickets.created_at DESC"))
      default_filter_params = {sorted_by: 'updated_at', resolved_filter: 1, answerer_filter: current_user.id, with_start_filter: Date.today-1.month, with_end_filter: Date.today + 2}
    end
    @filterrific = initialize_filterrific(
      filterrific_student,
      params[:filterrific],
      select_options: {
        sorted_by: Ticket.options_for_sorted_by,
        tag_filter: tags,
        answerer_filter: User
                             .where('role >= ? AND first_name is NOT ?', User.roles[:tutor], nil)
                             .sort { |a, b| a.full_name <=> b.full_name }
                             .map { |u| [u.full_name, u.id] },
        asker_filter: User
                             .where('role = ? AND first_name is NOT ?', User.roles[:student], nil)
                             .sort { |a, b| a.full_name <=> b.full_name }
                             .map { |u| [u.full_name, u.id] },
        resolved_filter: Ticket.options_for_statuses,
        complaint_filter: ['Yes', 'No'],
        feedback_filter: ['Yes', 'No']
      },
      default_filter_params: default_filter_params,
      :persistence_id => true
    ) or return
    @downloads_tickets = @filterrific.find.includes(:answerer, :resolver, :tags)
    @tickets = @filterrific.find.paginate(page: params[:page], per_page: 20).includes(:answerer, :resolver, :tags)
    master_feature = current_user.accessible_features.find_by('name LIKE?', '%ClarityFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    @autoemail = Autoemail.find_or_initialize_by(category: 0)
    date = "#{Date.today}"
    respond_to do |format|
      format.html
      format.js
      format.xls {
        response.headers['Content-Disposition'] = 'attachment; filename="unresolved_issues - ' + date + '.xls"'
      }
    end
  end

  def purchase_summary
    #   Logic of below. Grab the purchased enrolments then maps out all the feature enrolments (which is what a purchase
    # addon creates. This is the flattened and compacted so its just one array and no nil values, because we want purchased
    # ones only, we select active ones that have a purchase_item associated as only ones purchased by the user fit that
    # criteria)
    @purchased_enrolments = current_user.paid_enrolments.includes(:course, [purchase_item: [order: [:generated_promo]]])
    # Grabs all the enrolments that current user set as the user (being only ones that have been purchased)
    #   Logic of above. Grab the purchased enrolments then maps out all the feature enrolments (which is what a purchase
    # addon creates. This is the flattened and compacted so its just one array and no nil values, because we want purchased
    # ones only, we select active ones that have a purchase_item associated as only ones purchased by the user fit that
    # criteria)
    @purchased_addons = current_user.purchased_addons
    @purchased_addons = [] if @purchased_addons.nil?
  end

  def mcqs_count
    return redirect_to dashboard_mcq_counter_path(format: "xls", with_level: params[:with_level], published_tag_count: params[:published_tag_count], locate_tag_count: params[:locate_tag_count], exam_tag_count: params[:exam_tag_count]) if params[:excel]=="Download CSV"
    if params[:with_level].present?
      if params[:with_level]=="All"
        @tags=Tag.all
      else
        @tags = Tag.find_by_id(params[:with_level])
      end
    end

    published_select = params[:published_tag_count].present? ? params[:published_tag_count] : "All"
    location_select = params[:locate_tag_count].present? ? params[:locate_tag_count] : "All"
    exam_select = params[:exam_tag_count].present? ? params[:exam_tag_count] : "All - Duplicates Not Counted"
    @difficulties   = []
    if @tags.present?
      @tags.walk_tree do |tag, level|
        info = {
          name: tag.name,
          level: level,
          easy: 0,
          medium: 0,
          hard: 0,
          total: 0
        }
        tag_ids =[]
        tag.self_and_descendants.each do |t|
          tag_ids << t.self_and_descendants_ids
        end
        if params[:locate_tag_count].present? && params[:locate_tag_count] == "Online Exams"
          if params[:exam_tag_count] == "All - Duplicates Counted"
            results = Mcq.joins(:mcq_stem, :tagging).examinable_filter( published_select,params[:exam_tag_count]).online_exam_mcq(exam_select).where(taggings: { tag_id: tag_ids.flatten})
          else
            results = Mcq.includes(:mcq_stem, :tagging).published_mcq(published_select).examinable_filter( published_select).online_exam_mcq(exam_select).where(taggings: { tag_id: tag_ids.flatten}).uniq
          end
        else
          results = Mcq.includes(:mcq_stem, :tagging).published_mcq(published_select).examinable_mcq_filter(location_select).online_exam_mcq(exam_select).where(taggings: { tag_id: tag_ids.flatten}).uniq
        end
        results.each do |mcq|
            info[:easy]   += 1 if (0 ..33 ).include? mcq.difficulty
            info[:medium] += 1 if (34..66 ).include? mcq.difficulty
            info[:hard]   += 1 if (67..101).include? mcq.difficulty
            info[:total]  += 1
          end
        @difficulties.append(info)
      end
    end
    date = "#{Date.today}"
    respond_to do |format|
      format.html
      format.json
      format.js
      format.xls {
        response.headers['Content-Disposition'] = 'attachment; filename="mcq_counter - ' + date + '.xls"'
      }
    end
  end

  def mcq_counter
    redirect_to root_path and return if current_user.student?
    mcqs_count
  end

  def published_filter_mcq_counter
    mcqs_count
  end

  def mock_exam_essays
    redirect_to root_path and return if current_user.student?
    params[:filterrific] ||= {}
    params[:filterrific][:course_status] = params[:filterrific][:course_status] || 'Current'
    params[:filterrific][:with_start] = params[:filterrific][:with_start] || Date.today - 1.month
    params[:filterrific][:with_end] = params[:filterrific][:with_end] || Date.today
    params[:filterrific][:with_status] = params[:filterrific][:with_status] || MockExamEssay.statuses[:marked]
    @filterrific = initialize_filterrific(
        MockExamEssay,
        params[:filterrific],
        select_options: {
          status: [['Unsubmitted', 0], ["Submitted", 1], ["Marked", 2], ['Partially Marked', '3']],
          by_student: User.joins(:mock_exam_essays).uniq.map { |c| [c.full_name, c.id] },
          staff: User.all_staff.map{|e| [e.full_name,e.id]},
          marked_tutor: User.all_staff.map{|e| [e.full_name,e.id]},
          course: Course.joins(:mock_exam_essays).uniq.map { |c| [c.name] },
          course_status: [['Current'], ['All'], ['Archived']]
        }
    ) || return
    @total_responses = @filterrific.find.order(created_at: :desc)
    @mock_exam_essays = @total_responses.paginate(page: params[:page], per_page: 50)
    if current_user.tutor?
      @mock_exam_essays = @mock_exam_essays.where("#{current_user.id} = ANY (mock_exam_essays.assigned_tutors)")
    end
    @tutors = User.tutor.includes(:tutor_profile, :staff_profile).where("tutor_profiles.id IS NOT NULL AND staff_profiles.id IS NOT NULL").references(:tutor_profiles, :staff_profiles).sort { |a, b| a.full_name <=> b.full_name }
  end

  def online_mock_exam_essays
    redirect_to root_path and return if current_user.student?
      params[:filterrific] ||= {}
      params[:filterrific][:by_current_user] = current_user.id
      params[:filterrific][:course_status] = params[:filterrific][:course_status] || 'Current'
      params[:filterrific][:submitted_start_date] = params[:filterrific][:submitted_start_date] || Date.today - 1.month
      params[:filterrific][:submitted_with_end] = params[:filterrific][:submitted_with_end] || Date.today
    @filterrific = initialize_filterrific(
        EssayResponse,
        params[:filterrific],
        select_options: {
          status: [["Unmarked"],["Marked"],["Has feedback"], ['Unsubmitted'], ['Expired']],
          staff: User.all_staff.map{|e| [e.full_name,e.id]},
          to_submitter: User.all_staff.map{|e| [e.full_name,e.id]},
          by_current_user: current_user.id,
          course_status: [['Current'], ['All'], ['Archived']]
        }
    ) || return
    @total_responses = @filterrific.find.order(created_at: :desc)
    @responses = @total_responses.where.not(assessment_attempt_id: nil).paginate(page: params[:page], per_page: 50)
    @tutors = User.tutor.includes(:tutor_profile, :staff_profile).where("tutor_profiles.id IS NOT NULL AND staff_profiles.id IS NOT NULL").references(:tutor_profiles, :staff_profiles).sort { |a, b| a.full_name <=> b.full_name }
    respond_to do |format|
      format.html
      format.js
    end
    rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def purchase_addons
    @paid_at = current_user.current_enrolment.paid_at
    @product_version = current_user.paid_enrolments.last.course.product_version
    @inactive_features = current_user.paid_enrolments.last.inactive_features.map { |f| f.feature }
    @active_features = current_user.paid_enrolments.last.course.product_version.features

    tut_feat = @active_features.select { |feat| feat.private_tutoring? }.first
    if tut_feat
      (1..3).each do |i|
        feat = Feature.find_by_id(tut_feat.id)
        if (!tut_feat.price.nil?) and (!tut_feat.tutor_time.nil?) and (tut_feat.tutor_time != 0)
          feat.price = i * tut_feat.price.to_f / tut_feat.tutor_time
          feat.tutor_time = i
          feat.save!
        else
          # TODO: remove this after launch
          tut_feat.price = 100
          tut_feat.tutor_time = i
          tut_feat.save!
          feat.price = i*100
          feat.tutor_time = i
          feat.save!
        end
        @inactive_features << feat
      end
    end
  end

  def update_tutors_select
    @tutors = User.options_for_select_by_subject params[:select_id]
    respond_to do |format|
      format.js
    end
  end

  def textbooks
    check_background_informaation
    attendance_feature = current_user.accessible_features.find_by('name LIKE?', '%AttendanceTutorialsFeature%')
    attendance_feature = current_user.accessible_features.find_by('name LIKE?', '%DocumentsFeature%') if ((current_user.active_course.present? &&current_user.active_course.name.include?("InterviewReady")) && attendance_feature.nil?)
    textbook_feature = current_user.accessible_features.find_by('name LIKE?', '%TextbookFeature%')
    if current_user.student?
      ol_textbook = current_user.enrolments.find_by(course_id: current_course.id).online_textbook?
    end
    online_textbook = textbook_feature.present? || ol_textbook.present?

    if (current_user.student? && online_textbook && attendance_feature.present?) || !current_user.student?
      @types = ['textbook_chapters', 'textbook_slides', 'attendance_course_resources', 'attendance_course_slides', 'supplementary_resources', 'downloadable_resources']
    elsif current_user.student? && online_textbook && !attendance_feature.present?
      @types = ['textbook_chapters', 'textbook_slides', 'supplementary_resources', 'downloadable_resources']
    elsif current_user.student? && !online_textbook && attendance_feature.present?
      @types = ['attendance_course_resources', 'attendance_course_slides', 'supplementary_resources', 'downloadable_resources']
    elsif current_user.student? && !online_textbook && !attendance_feature.present?
      @types = ['supplementary_resources', 'downloadable_resources']
    elsif current_user.student? && !online_textbook && attendance_feature.present?
      @types = ['attendance_course_resources', 'attendance_course_slides', 'supplementary_resources', 'downloadable_resources']
    elsif current_user.student? && online_textbook && attendance_feature.present?
      @types = ['textbook_chapters', 'textbook_slides', 'attendance_course_resources', 'attendance_course_slides', 'supplementary_resources', 'downloadable_resources']
    elsif current_user.student? && online_textbook && !attendance_feature.present?
      @types = ['textbook_chapters', 'textbook_slides', 'supplementary_resources', 'downloadable_resources']
    else
      @types = ['supplementary_resources', 'downloadable_resources']
    end

    if !current_user.student?
      if !@types.include?("additional_chapters")
        @types.insert(0, "additional_chapters") 
      end

    end


    if current_user.student?
      if current_user.enrolments.find_by(course_id: current_user.active_course_id).hardcopy?
        @types.insert(2, "textbook_hardcopy")
      end
      # textbook_feat = current_user.accessible_features.find_by('name LIKE?', '%TextbookFeature%')
      textbook_hard_cpy_feat = current_user.accessible_features.find_by('name LIKE?', '%TextbookHardCopyFeature%')
      textbook_online = current_user.accessible_features.find_by('name LIKE?', '%GamsatTextbookFeature%')
      if !@types.include?("additional_chapters")
        @types.insert(0, "additional_chapters") if textbook_online.present?
      end
      if textbook_hard_cpy_feat.present? && (!@types.include?("textbook_chapters"))
        if (@types[0] == 'additional_chapters')
          @types.insert(1, "textbook_chapters") 
        else
          @types.insert(0, "textbook_chapters") 
        end
      end
      weekend_feature = current_user.accessible_features.find_by('name LIKE?', '%WeekendCourse%')
      @types << "weekend_course_slides" if weekend_feature.present?
      @types.insert(-4, "revision_weekend") if weekend_feature.present? && !@types.include?("mock_exam")
      @types.insert(-5, "revision_weekend") if weekend_feature.present? && @types.include?("mock_exam")
      mock_exam_feat = current_user.accessible_features.find_by('name LIKE?', '%GamsatExamFeature%')
      @types.insert(-3, "mock_exam") if mock_exam_feat.present? && !weekend_feature.present?
      @types.insert(-4, "mock_exam") if mock_exam_feat.present? && weekend_feature.present?
     
      # Temporary added last 2 lines for GRAD-2932
      # @types << "attendance_course_slides" if weekend_feature.present?
      # @types = @types.uniq
    else 
      mock_exam_feat = current_user.accessible_features.find_by('name LIKE?', '%GamsatExamFeature%')
      weekend_feature = current_user.accessible_features.find_by('name LIKE?', '%WeekendCourse%')
      @types << "weekend_course_slides"
      @types.insert(5, "revision_weekend") 
      @types.insert(6, "mock_exam") 
    end

    # if current_user.student?
    #   supp_pos =0
    #   weekend_pos=0
    #   supp_pos= @types.find_index("supplementary_resources") if @types.include?("supplementary_resources")
    #   weekend_pos= @types.find_index("revision_weekend") if @types.include?("revision_weekend")

    #   weekend_feature = current_user.accessible_features.find_by('name LIKE?', '%WeekendCourse%')
    #   @types.insert(supp_pos-1,"revision_weekend") if weekend_feature.present? && !@types.include?("revision_weekend") && supp_pos !=0 && !@types.include?("mock_exam")

    #   @types.insert(supp_pos-2,"revision_weekend") if weekend_feature.present? && !@types.include?("revision_weekend") && supp_pos !=0 && @types.include?("mock_exam")

    #   @types.prepend("revision_weekend") if weekend_feature.present? && !@types.include?("revision_weekend") && supp_pos == 0
      
    #   mock_exam_feat = current_user.accessible_features.find_by('name LIKE?', '%GamsatExamFeature%')
    #   @types.insert(supp_pos, "mock_exam") if mock_exam_feat.present? && supp_pos != 0


    #   @types.prepend("mock_exam") if mock_exam_feat.present? && !@types.include?("mock_exam") && supp_pos == 0
    # end
    if params[:type].present?
      @type = params[:type]
    else
      @type = @types[0]
    end
    @type = params[:filterrific][:type] if params[:filterrific].present?

    master_feature = current_user.accessible_features.find_by('name LIKE?', '%TextbookFeature%')
    master_feature = current_user.accessible_features.find_by('name LIKE?', '%DocumentsFeature%') unless master_feature.present?
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    policy_textbooks = policy_scope(Textbook)
    @types.each do |type|
      textbooks = policy_textbooks.by_type(type, current_user)
      if current_user.student? && type == 'downloadable_resources'
        course_type = current_user.active_course.try(:product_version).try(:course_type)
        course_type = ProductVersion.course_types[course_type]
        case course_type
        when 0, 10
          text_books = textbooks.includes(:course).where("(for_trial = true OR for_timetable = true) AND (document_file_name IS NOT NULL) AND (course_id IS NULL OR (course_id = (?) AND courses.visible_to_student = true))", current_course.try(:id) ).references(:courses)
        else
          text_books = textbooks.includes(:course).where("(for_paid = true OR for_timetable = true) AND (document_file_name IS NOT NULL) AND (course_id IS NULL OR (course_id = (?) AND courses.visible_to_student = true))", current_course.try(:id) ).references(:courses)
        end
      end
      unless textbooks.present?
        @types = @types - [type]
      end
    end
    @textbooks = policy_textbooks.by_type(@type, current_user)

    if current_user.student?
      @filterrific = initialize_filterrific(
        @textbooks,
        params[:filterrific],
        select_options: {
        by_tag: current_course.tags_cache.map{ |tag| [tag.name, tag.id] },
        sorted_by: Textbook.options_for_sorted_by,
      }) or return
    else
      @filterrific = initialize_filterrific(
        @textbooks,
        params[:filterrific],
        select_options: {
        by_tag: Tag.all.order(:name).map{ |tag| [tag.name, tag.id] },
        sorted_by: Textbook.options_for_sorted_by,
        by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc'],
      }) or return
    end
    if @type == 'downloadable_resources'
      if current_user.student?
        course_type = current_user.active_course.try(:product_version).try(:course_type)
        course_type = ProductVersion.course_types[course_type]
        case course_type
        when 0, 10
          text_books = @filterrific.find.includes(:course).where("(for_trial = true OR for_timetable = true) AND (document_file_name IS NOT NULL) AND (course_id IS NULL OR (course_id = (?) AND courses.visible_to_student = true))", current_course.try(:id) ).references(:courses)
        else
          text_books = @filterrific.find.includes(:course).where("(for_paid = true OR for_timetable = true) AND (document_file_name IS NOT NULL) AND (course_id IS NULL OR (course_id = (?) AND courses.visible_to_student = true))", current_course.try(:id) ).references(:courses)
        end
      else
        text_books = @filterrific.find.where.not(document_file_name: nil)
      end

      @textbooks = text_books.order(:title).paginate(page: params[:page], per_page: 20)
    else
      @textbooks = @filterrific.find.order(:title).paginate(page: params[:page], per_page: 20)
    end
    rescue ActiveRecord::RecordNotFound => e
      puts "Had to reset filterrific params: #{e.message}"
      redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def filtered_topics
    if params[:type].present?
      @options = Tag.by_product_line(params[:type])
    else
      @options = Tag.all.order(:name)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def vods
    # (@filterrific = initialize_filterrific(
    #     Vod,
    #     params[:filterrific],
    #     select_options: {
    #         with_video_category: VideoCategory.options_for_select,
    #         with_subject: Subject.options_for_filter_select
    #     }
    # )) or return
    # if @course_versions
    #   @vods = Vod.for_course(@course_versions.course).filterrific_find(@filterrific).page(params[:page])
    # else
    #   # @vods = []
    #   # TODO Temprary schow all if not in course
    #   @vods = @filterrific.find.page(params[:page])
    # end

    # @vods_arr = current_user.courses.flat_map(&:product_version).flat_map(&:tags).flat_map(&:vods)
    #

    @filterrific = initialize_filterrific(
        policy_scope(Vod),
        params[:filterrific]
    ) or return
    @vods = policy_scope(Vod).paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.js
    end

    rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def student
    @courses = current_user.dashboard_courses
    @surveys = current_user.dashboard_surveys
    @essays = current_user.dashboard_essays
  end

  def admin
  end

  def courses
    @announcement = get_announcement('Courses')
    @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id) if @announcement.present?
    @courses = current_user.courses.order(:name).uniq
    current_user.courses.order(:name).uniq
  end

  def surveys
    @surveys = current_user.dashboard_surveys
  end

  def essays
    @essays = current_user.dashboard_essays
  end

  def mcq_stems
    @mcq_stems = policy_scope(McqStem).paginate(page: params[:page])
  end

  def create_mcqs
    @mcq_stem = McqStem.new
  end

  def important_dates
    @date = params[:date]
    @events = User.important_calender_dates(@date, current_user, current_course)
  end

  def manage_mcqs
    stem_students = StemStudent.stems_for_student(current_user.id).order(created_at: :desc)

    (@filterrific = initialize_filterrific(
        StemStudent,
        params[:filterrific],
        select_options: {
            with_tag_id: Tag.options_for_select,
            with_subject: Subject.options_for_stem_students
        }
    )) or return
    @stem_students = stem_students.filterrific_find(@filterrific).page(params[:page])
      # respond_with(@mcq_stems)

  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  # def exams
  #   @exams = Exam.for_student(current_user)
  # end

  def events
    render json: nil
  end

  def hide_announcement
    user_announcement = current_user.user_announcements.find(params[:id])
    if user_announcement.update_attribute(:viewed, true)
      result = true
    else
      result = false
    end
    render json: result
  end

  private

  def check_date_range
    return unless params[:filterrific].present?
    start_date = params[:filterrific][:with_start]
    end_date = params[:filterrific][:with_end]
    return if start_date == nil || end_date == nil
    if end_date.to_date < start_date.to_date
      redirect_to dashboard_book_tutor_path
      flash[:error] = 'The end date cannot be earlier than start date. Please review your date selection.'
    end
  end

  def check_expired_courses
    if current_user.student? && (current_user.accessible_features.select{|p| p.title == "Textbooks" || "Book Tutor"}.blank?)
      redirect_to root_path
    end
  end

  def filterrific_params
    if params[:filterrific]
      params.require(:filterrific).permit(:with_tag, :with_start, :with_end, :with_location, :with_tutor_name, :with_tutor_id)
    end
  end

  def resolve_layout
    case action_name
    when 'home', 'calender', 'book_tutor', 'textbooks', 'unresolved_issues', 'upgrade', 'no_access'
      current_user.student? ? 'student_page' : 'dashboard'
    else
      'dashboard'
    end
  end
end
