class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_access_allowed!, except: [ :trial_enabled, :set_current_course, :show, :update_course_id, :get_addons]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :trial_enabled, :duplicate, :unarchived, :update_course_id]
  layout 'layouts/dashboard'
  respond_to :html

  def filterrifc(courses)
    (@filterrific = initialize_filterrific(
        @courses,
        params[:filterrific],
        select_options: {
            with_city: Course.options_for_city,
            with_pv: ProductVersion.all.map{|p| [p.name, p.id]}.sort_by { |name, id| name },
            by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    )) || return
    @courses = @filterrific.find.order(:name).paginate(page: params[:page], per_page: 20)
    @all_courses = @filterrific.find.order(:name)
    rescue ActiveRecord::RecordNotFound => e
      puts "Had to reset filterrific params: #{e.message}"
      redirect_to(reset_filterrific_url(format: :html)) && return
    respond_to do |format|
      format.html
      format.json
      format.js
      format.xls
      format.xlsx
    end
  end

  def index
    @courses = Course.active_courses.order(:name)
    filterrifc(@courses)
    date = "#{Date.today}"
    respond_to do |format|
      format.html
      format.json
      format.js
      format.xls
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Courses - ' + date + '.xlsx"'
      }
    end
  end

  def student_enrolement_process
    @courses = Course.active_courses.order(:name)
    filterrifc(@courses)
  end

  def archived_courses
    @courses = Course.archived_courses.order(:name)
    filterrifc(@courses)
    date = "#{Date.today}"
    respond_to do |format|
      format.html
      format.json
      format.js
      format.xls
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="archived_courses - ' + date + '.xlsx"'
      }
    end
  end

 

  def get_course_type
    product_version_id = params[:product_version_id]
    course_type = ProductVersion.find(product_version_id).freemium
    if course_type
      render json: {success: true, status: "show"}
    else
      render json: {success: true, status: "hide"}
    end
  end

  
  

  def trial_enabled
    render json: { trial_enabled: @course.trial_enabled }
  end

  def show
    file_name = @course.name.to_s + " - #{Date.today}"
    @enroled_student_list = @course.enroled_student_list.paginate(page: params[:page] || 1, per_page: 50)
    @placeholder_student_list = @course.placeholder_student_list

    respond_to do |format|
      format.html
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="' + file_name + '.xlsx"'
      }
    end
  end

  def public_course_cities
    @product_version = ProductVersion.find_by(id: params['product_id'])
    @cities = Course.where(product_version_id: @product_version.id).where('enrolment_end_date >= ? OR remain_visible = ?', Time.zone.now.beginning_of_day, true).collect(&:city).uniq.compact.sort
    @course_type = params[:type]

    if params[:city].present?
      @first_city = params[:city]
      @courses = Course.where(product_version_id: @product_version.id, city: Course.cities[@first_city]).where('enrolment_end_date >= ? OR remain_visible = ?', Time.zone.now.beginning_of_day, true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible }
      @selected_course = @courses.first
    else
      @course = Course.find_by(id: params[:course_id])
      if @course.present?
        @first_city = @course.city
      else
        @first_city = nil
      end
      @courses = Course.where(product_version_id: @product_version.id, city: Course.cities[@first_city]).where('enrolment_end_date >= ? OR remain_visible = ?', Time.zone.now.beginning_of_day,true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible }
      @selected_course = @course
    end
  end

  def new
    @course = Course.new
    @course.lessons.build
    @course.textbooks.build
    respond_with(@course)
  end

  def edit
    @course.lessons.build if @course.lessons.empty?
    @course.textbooks.build if @course.textbooks.empty?
    @lessons = @course.lessons.order(:date) if @course.lessons.first.date.present?
  end

  def create
    @course = Course.new(course_params)
    if @course.product_version.present? && @course.product_version.name == "GM 3.1 Free Trial"
      @course.customable = true
    end
    if @course.save
      flash[:notice] = 'Course was successfully created.'
    else
      flash[:error] = 'Please review the problems below.'
    end
    respond_with(@course)
  end

  def update
    @old_staff_pf_ids = @course.staff_profile_ids

    begin
      @course.update!(course_params)
    rescue StandardError => e
      redirect_to(edit_course_path(@course), alert: e.message)
      return
    end

    if @course.product_version.present? && @course.product_version.name == "GM 3.1 Free Trial"
      @course.update(customable: true)
    end
    if params[:course][:textbooks_attributes] && params[:course][:textbooks_attributes][:document].present? && params[:course][:visible_to_student] == "1" && params[:course][:notify_student] == "1"
      CoursesMailer.update_time_timetable_mail(@course).deliver_later
    end
    if params[:course][:transfer_data_to_tutor] == '1'
      transfer_essay_data(@old_staff_pf_ids)
    end
    # respond_with(@course)

    redirect_to edit_course_path(@course), notice: 'Course updated successfully.'
    ## Added for task 2922
    arr  = @old_staff_pf_ids - @course.staff_profile_ids
    if !arr.empty?
      old_staffs = StaffProfile.where(id: @old_staff_pf_ids)
      new_staffs = StaffProfile.where(id: @course.staff_profile_ids)
      old_staffs.each do |os|
        CoursesMailer.inform_old_staff(os.staff, @course).deliver_later
      end
      new_staffs.each do |os|
        CoursesMailer.inform_new_staff(os.staff, @course).deliver_later
      end
      @course.update_essay_response_tutor(@course.staff_profile_ids.first)
    end
  end

  def transfer_essay_data(staff_ids)
    old_id = StaffProfile.find(staff_ids.first).staff_id
    new_id = StaffProfile.find(@course.staff_profile_ids.first).staff_id
    if old_id != new_id
      essay_responses = EssayResponse.where(course_id: @course.id)
      mock_exam_essays = MockExamEssay.where(course_id: @course.id)
      essay_responses.update_all(tutor_id: new_id)
      mock_exam_essays.update_all(assigned_tutors: [new_id])
      @staff = User.find(new_id)
      @staff.update_attribute(:essay_transferred, false)
    end
  end

  def destroy
    @course.destroy
    respond_with(@course)
  end

  def set_current_course
    if params[:course_id].present?
      current_user.update_attribute(:active_course_id, params[:course_id])
      session[:validate_feature_log] = nil
      course_name = Course.find(params[:course_id]).try(:name)
    end
    redirect_back fallback_location: root_path, notice: "#{course_name} was successfully activated."
  end

  def duplicate
    course= @course
    @course_service=CourseService.new(course, params)
    msg,duplicate_course=@course_service.duplicate
    redirect_to edit_course_path(duplicate_course), notice: msg
  end

  
  def unarchived
    @course.update(show_archived: true)
    redirect_to archived_courses_courses_path, notice: 'Course was made unarchived'
  end

  def update_course_id
    if current_user.student?
      order = current_user.validate_order
      order.update_attribute(:course_id, @course.try(:id))
    end
    render "errors/not_found"
  end

  def get_addons
    @course = Course.find_by(id: params[:id])
    @enrolment = Enrolment.find_by(id: params[:enrolment_id])
    @course_type = params[:course_type].to_i
    @order = Order.find_by(id: params[:order_id])
    if params[:city] == "Other"
      no_ids = @course.product_version.product_version_feature_prices.includes(:master_feature).where('is_default = false AND is_additional = false AND master_features.name iLIKE ANY ( array[?] )', ['%LiveMockExamFeature%', '%AttendanceTutorialsFeature%']).references(:master_features)
      @pvpfs = @course.product_version.product_version_feature_prices.includes(:master_feature).where(is_default: false, is_additional: false).where.not(id: no_ids).order('master_features.popular_order')
    else
      @pvpfs = @course.product_version.product_version_feature_prices.includes(:master_feature).where(is_default: false, is_additional: false).order('master_features.popular_order')
    end
  end

  def update_paypal  
    @course = Course.where(id: params[:course_id])
    @course.update_all(paypal_only: params[:paypal_only])
    flash[:success] = "Course updated successfully."
  end

  private

  def ensure_access_allowed!
    user_not_authorized unless [:manager, :admin, :superadmin].include? current_user.role.to_sym
  end

  def set_course
    @course = Course.find_by(slug: params[:id]) || Course.find_by(id: params[:id])
  end

  def check_product_version
    redirect_to gamsat_path if !params[:product_id].present?
  end
 
  

  def course_params
    params[:course][:city] = params[:course][:city].to_i if params[:course][:city]
    params.require(:course).permit(
      :name,
      :class_size,
      :city,
      :expiry_date,
      :enrolment_end_date,
      :remain_visible,
      :paypal_only,
      :paypal_days,
      :product_version_id,
      :trial_enabled,
      :trial_period_days,
      :visible_to_student,
      :notify_student,
      :link_with_homepage_ft,
      staff_profile_ids: [],
      lessons_attributes: [
        :id,
        :date,
        :location,
        :start_time,
        :end_time,
        :lesson_type,
        :item_covered,
        :_destroy
      ],
      textbooks_attributes: [
        :id,
        :for_timetable,
        :user_id,
        :for_downloadable_resource,
        :document,
        :_destroy
      ]
    )
  end
end
