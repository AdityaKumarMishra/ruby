class EssayResponsesController < EssaysController
  before_action :authenticate_user!
  # before_action :check_student_essays
  before_action :set_essay_response, only: [:edit, :update, :show, :download, :assign_tutor, :update_tutor]
  before_action :set_essay, except: [:index, :to_mark, :tutor_essays, :filtered_tutor_essays, :new, :create, :submit, :download_tutor_essays, :assign_tutor, :download_marked_essays, :mass_update_tutor, :update_essays_tutor]
  # before_action :set_essay_time, except: :submit
  layout :resolve_layout
  respond_to :html

  def index
    current_user.remove_duplicate_essays_if_any(current_course) if current_user.student?
    master_feature = current_user.accessible_features.find_by('name LIKE?', '%EssayFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end

    @essays_responses = current_user.essay_responses.includes(:course, :essay, essay_tutor_response: [staff_profile: [:staff]]).where(courses: { id: current_course.try(:id) },assessment_attempt_id: nil).order('essays.position')
  end

  def new
    @essay_response = EssayResponse.new
    respond_with(@essay_response)
  end

  def create
    @essay_response = EssayResponse.new(essay_response_params)
    @essay_response.user = current_user
    if @essay_response.save
      flash[:notice] = 'EssayResponse was successfully created.'
      respond_with(@essay_response, location: essay_response_path)
    else
      flash[:error] = 'Please review the problems below.'
      respond_with(@essay_response)
    end
  end

  def show
    @user = @essay_response.user
    respond_to do |format|
      format.html
      format.pdf do
        pdf = EssayResponsePdf.new(@essay_response)
        send_data pdf.render, filename: "#{@essay_response.try(:user).try(:first_name)} - EssayResponse - #{@essay_response.id}.pdf", type: 'application/pdf'
      end
    end
  end

  def edit
  end

  def update
    if @essay_response.update(essay_response_params)
      @essay_response.update(elapsed_time: @essay_response.elapsed_time + (Time.now - params[:essay_response][:initial_time].to_time)*1000) if params[:essay_response][:initial_time].present?
      if params[:is_time_up]
        params[:essay_response_id] = @essay_response.id
        submit
      end
      unless params[:is_time_up]
        respond_to do |format|
          format.js { render 'edit'}
          format.html { respond_with(@essay_response, location: essay_response_path) }
          flash[:notice] = 'EssayResponse was successfully updated.'
        end
      end
    else
      unless params[:is_time_up]
        respond_to do |format|
          format.js { render 'edit'}
          format.html { respond_with(@essay_response, location: essay_response_path) }
          flash[:error] = 'Please review the problems below.'
        end
      end
    end
  end

  def download
    zip = EssayResponse.zip_applications(@essay_response)
    send_data(zip[:data], type: 'application/zip', filename: zip[:name])

  ensure
    zip[:temp_file].close if zip
    zip[:temp_file].unlink if zip
  end

  def submit
    @essay_response = EssayResponse.find(params[:essay_response_id])
    @essay_response.update_attribute(:time_submited, Time.now.in_time_zone("Australia/Melbourne"))
    @user = @essay_response.user

    if @essay_response.tutor.present?
      email = @essay_response.tutor.email
      tutor_emails = email == 'tt@gradready.com.au' ? email : [email, 'tt@gradready.com.au']
    else
      tutor_emails = @essay_response.course.staff_profiles.map{|s| s.staff.email} if @essay_response.course.present? && @essay_response.course.staff_profiles.present?
      tutor_emails = (tutor_emails << 'tt@gradready.com.au').uniq if tutor_emails.present?
    end

    @essay_response.unmarked!
    if tutor_emails.present?
      @essay_response.inform_tutor(tutor_emails)
    else
      EssayResponseMailer.no_tutor_essay(@essay_response).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
    end
    if @essay_response.assessment_attempt_id.present?
      if @essay_response.assessment_attempt.assessable.per_city_exam_count > 1
        redirect_to online_mock_exam_attempts_path
      else
        redirect_to online_mock_exam_attempt_temps_path
      end
      # redirect_to online_mock_exam_attempts_path
    else
      redirect_to essay_responses_path
    end
  end

  def tutor_essays
    redirect_to root_path and return if current_user.student?
    essay_status = params[:essay_status] ? params[:essay_status] : "Unmarked"
    tutor = params[:tutor_selected].present? ? User.find(params[:tutor_selected]) : current_user.tutor? ? current_user : nil
    # For Now only showing Essay Responses dates will be chnaged later
    
    essay_type = 'EssayResponse'
    dates = []
    if essay_type == 'MockExam'
      mock_dates = if essay_status == 'Unmarked'
                    mock_exam_essay_unmarked_dates(tutor)
                  else
                    mock_exam_essay_marked_dates(tutor)
                  end
      dates = dates + mock_dates
    elsif essay_type == 'EssayResponse'
      essay_dates = if essay_status == 'Unmarked'
                    @calendar_data = essay_response_unmarked_by_tutor_by_date(tutor)
                    essay_response_unmarked_dates(tutor)
                  else
                    essay_response_marked_dates(tutor)
                  end
      dates = dates + essay_dates
    else
      dates = dates + mock_exam_essay_unmarked_dates(tutor)
      dates = dates + mock_exam_essay_marked_dates(tutor)
      dates = dates + essay_response_unmarked_dates(tutor)
      dates = dates + essay_response_marked_dates(tutor)
    end
    @response_counts = Hash.new(0)
    dates.map{|d| d.strftime('%Y-%m-%d') }.each { |i| @response_counts[i] += 1 }
  end


  def download_tutor_essays
    @year = params[:year].to_i
    @month = Date::MONTHNAMES.index(params[:month])
    @status = params[:status]
    @tutor = params[:tutor]
    date1 = Date.new(@year,@month,1)
    date2 = Date.new(@year,@month,-1)
    # @courses = []
    @marked_dates = []

    if @status == "Unmarked"
      @responses = EssayResponse.includes(:user, course: :staff_profiles).where('courses.expiry_date > ? AND essay_responses.status IN (?) AND essay_responses.expiry_date > ? AND users.confirmed_at IS NOT NULL', Time.zone.now.in_time_zone("Australia/Melbourne"), [0,1], Time.zone.now.in_time_zone("Australia/Melbourne")).references(:courses).order(:expiry_date)
      if !current_user.tutor? && @tutor.blank?
        @responses = @responses
        @staff_profiles = StaffProfile.includes(:staff, courses: :essay_responses).order("users.first_name, users.last_name").where(essay_responses: {id: @responses.ids})
        # @staff_profiles2 = StaffProfile.includes(:staff, courses: :essay_responses).order("users.first_name, users.last_name").where(courses: {id: @courses})
        # @staff_profiles = @staff_profiles1 + @staff_profiles2
        # @staff_profiles = @staff_profiles.uniq
      else
        @responses = @responses.where(staff_profiles: { staff_id: @tutor })
        @staff_profiles = []
        @staff_profiles << User.find(@tutor).staff_profile
      end

      file_name = "Essasy To Mark"
    else

      if !current_user.tutor? && @tutor.blank?
        @responses = EssayTutorResponse.with_year_and_month(@year, @month).where('essay_tutor_responses.staff_profile_id IS NOT ?', nil)
        @staff_profiles = StaffProfile.includes(:staff, :essay_tutor_responses).order("users.first_name, users.last_name").where(essay_tutor_responses: {id: @responses})
        # @staff_profiles2 = StaffProfile.includes(:staff, courses: :essay_responses).order("users.first_name, users.last_name").where(courses: {id: @courses})
        # @staff_profiles = @staff_profiles1 + @staff_profiles2
      else
        @responses = EssayTutorResponse.with_year_and_month(@year, @month).includes(:staff_profile).where(staff_profiles: {staff_id: tutor_selected.id})
        @staff_profiles = []
        @staff_profiles << User.find(@tutor).staff_profile
      end
      file_name = "Essays Marked"
    end
    respond_to do |format|
      format.xls {
        response.headers['Content-Disposition'] = 'attachment; filename="' + file_name + '.xls"'
      }
    end
  end

  def download_marked_essays
    dates = params[:period].split(" - ")
    start_date = dates[0]
    end_date = dates[1]
    if params[:tutor].present?
      @tutor = User.find(params[:tutor])
      etr_ids = EssayTutorResponse.with_paycycle(start_date, end_date).pluck(:id)
      if etr_ids.present?
        sql = "SELECT DISTINCT ON (essay_tutor_responses.essay_response_id) essay_tutor_responses.* FROM essay_tutor_responses LEFT JOIN staff_profiles ON essay_tutor_responses.staff_profile_id = staff_profiles.id LEFT  JOIN essay_responses ON essay_tutor_responses.essay_response_id = essay_responses.id WHERE essay_tutor_responses.id IN ("+etr_ids.join(',')+") AND staff_profiles.staff_id = $1 AND essay_responses.assessment_attempt_id IS NULL"
        bindings = [[nil, @tutor.id]]
        @responses = ActiveRecord::Base.connection.exec_query(sql, 'SQL', bindings)
      else
        @responses = []
      end
      # @responses = EssayTutorResponse.with_paycycle(start_date, end_date).includes(:staff_profile).where(staff_profiles: {staff_id: @tutor.id})
      @mock_responses = MockEssayFeedback.with_paycycle(start_date, end_date).includes(mock_essay: :mock_exam_essay).where(mock_exam_essays: { status: 2 }, user_id: @tutor.id)
    else
      etr_ids = EssayTutorResponse.with_paycycle(start_date, end_date).pluck(:id)
      if etr_ids.present?
        sql = ("SELECT DISTINCT ON (essay_tutor_responses.essay_response_id) essay_tutor_responses.* FROM essay_tutor_responses LEFT JOIN essay_responses ON essay_tutor_responses.essay_response_id = essay_responses.id WHERE essay_tutor_responses.id IN ("+etr_ids.join(',')+") AND essay_tutor_responses.staff_profile_id IS NOT NULL AND essay_responses.assessment_attempt_id IS NULL")
        ids = []
        results = ActiveRecord::Base.connection.exec_query(sql)
        results.each {|r| ids << r["id"]}
        @responses = EssayTutorResponse.where(id: ids)
      else
        @responses = []
      end
      # @responses = EssayTutorResponse.with_paycycle(start_date, end_date).where.not(staff_profile_id: nil)
      @mock_responses = MockEssayFeedback.with_paycycle(start_date, end_date).includes(mock_essay: :mock_exam_essay).where(mock_exam_essays: { status: 2 })
    end
    filename = "Essays Marked - " + params[:period]
    respond_to do |format|
      format.xls {
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.xls"'
      }
    end
  end

  def to_mark
    redirect_to root_path and return if current_user.student?
    unless params[:format].present? && params[:format] == "xlsx"
      params[:filterrific] ||= {}
      params[:filterrific][:by_current_user] = current_user.id
      params[:filterrific][:course_status] = params[:filterrific][:course_status] || 'Current'
      params[:filterrific][:submitted_start_date] = params[:filterrific][:submitted_start_date] || Date.today - 1.month
      params[:filterrific][:submitted_with_end] = params[:filterrific][:submitted_with_end] || Date.today
    end
    @filterrific = initialize_filterrific(
        EssayResponse,
        params[:filterrific],
        select_options: {
          status: [["Unmarked"],["Marked"],["Has feedback"], ['Unsubmitted'], ['Expired']],
          staff: User.all_staff.map{|e| [e.full_name,e.id]},
          to_submitter: User.all_staff.map{|e| [e.full_name,e.id]},
          by_current_user: current_user.id,
          course: Course.all.map { |c| [c.name]},
          course_status: [['Current'], ['All'], ['Archived']]
        }
    ) || return
    @total_responses = @filterrific.find.order(Arel.sql('time_submited IS NULL, time_submited DESC'))

    unmarked = @total_responses.where(status: 1)
    marked = @total_responses.where(status: 2..3)
    unanswered = @total_responses.where('essay_responses.status = (?) AND essay_responses.expiry_date >= ?', 0, Date.today)
    expired = @total_responses.where('essay_responses.status = (?) AND essay_responses.expiry_date < ?', 0, Date.today)
    ordered_ids = unmarked.ids + marked.ids + unanswered.ids + expired.ids
    @responses = EssayResponse.includes(:tutor, :user, essay_tutor_response: [staff_profile: :staff]).where(id: ordered_ids).order((Arel.sql("idx(array[#{ordered_ids.join(',')}], id)")))
    @responses = @responses.where(assessment_attempt_id: nil).paginate(page: params[:page], per_page: 50)

    @tutors = User.tutor.includes(:tutor_profile, :staff_profile).where("tutor_profiles.id IS NOT NULL AND staff_profiles.id IS NOT NULL").references(:tutor_profiles, :staff_profiles).sort { |a, b| a.full_name <=> b.full_name }

    @all_essay_responses = @filterrific.find

    respond_to do |format|
      format.html
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Marking-Overdue Stats.xlsx"'
      }
    end

  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def assign_tutor
    remove_ids = [current_user.id,  @essay_response.tutor.id]
    @tutors = User.tutor.where.not(id: remove_ids).includes(:tutor_profile, :staff_profile).where("tutor_profiles.id IS NOT NULL AND staff_profiles.id IS NOT NULL").references(:tutor_profiles, :staff_profiles).sort { |a, b| a.full_name <=> b.full_name }
  end

  def update_tutor
    tutor = @essay_response.tutor
    if @essay_response.update_attribute(:tutor_id, params[:tutor])
      user = User.find(params[:tutor])
      EssayResponseMailer.new_tutor_assigned(@essay_response).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
      # EssayResponseMailer.inform_old_tutor(@essay_response, tutor).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
      EssayResponseMailer.essay_reassignment_email(@essay_response, tutor).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"

      redirect_to @essay, notice: 'Essay is successfully assigend!'
    else
      redirect_to @essay, error: 'Error is assiging essay!'
    end
  end

  def mass_update_tutor
    if params[:assign_essays]['responses_ids'].present? && params[:tutor].present?
      tutor = User.find(params[:tutor])
      ids = if cookies["to_mark_essay"] == "true"
              params[:total_response_ids].split(" ")
            else
              params[:assign_essays]['responses_ids']
            end
      essay_responses = EssayResponse.where(id: ids)
      essay_responses.update_all('old_tutor_id = tutor_id')
      if essay_responses.update_all(tutor_id: params[:tutor])
        essay_responses.each do |essay_response|
          old_tutor = User.find_by(id: essay_response.old_tutor_id)
          EssayResponseMailer.new_tutor_assigned(essay_response).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
          EssayResponseMailer.inform_old_tutor(essay_response, old_tutor).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
          EssayResponseMailer.essay_reassignment_email(essay_response, tutor).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        end
        redirect_to request.referrer, error: 'Essay responses is successfully assigend!'
      else
        redirect_to request.referrer, error: 'Error is assiging tutor to essay responses!'
      end
    else
      redirect_to request.referrer, error: 'You have not selected either essay responses or tutor!'
    end
  end

  def update_essays_tutor
    response = "Tutor Not Updated"
    essay_responses = EssayResponse.where(user_id: params[:user_id], course_id: params[:course_id], status: 0)
    tutor = User.find_by(id: params[:tutor_id])
    if essay_responses.present? && tutor.present?
      essay_responses.update_all(tutor_id: tutor.id)
      response = "Tutor Updated"
    end
    respond_to do |format|
      format.json { render json: {response: response}, status: :ok }
    end
  end

  private
    def set_essay_response
      @essay_response = EssayResponse.friendly.find(params[:id])
    end

    def set_essay
      @essay = @essay_response.essay
    end

    def set_essay_time
    end

    def essay_response_params
      params.require(:essay_response).permit(:response, :id, :essay_id, :time_submited)
    end

    def resolve_layout
      (action_name == 'index' || action_name == 'edit' || action_name == "show") && current_user.student? ? 'student_page' : 'dashboard'
    end

    def mock_exam_essay_unmarked_dates(tutor)
      if tutor.present?
        MockExamEssay.where(status: 0).where("#{tutor.id} = ANY (mock_exam_essays.assigned_tutors)").map{|s| s.created_at.to_date}
      else
        MockExamEssay.where(status: 0).map{|s| s.created_at.to_date}
      end
    end

    def mock_exam_essay_marked_dates(tutor)
      if tutor.present?
        MockEssayFeedback.includes(mock_essay: :mock_exam_essay).where(mock_exam_essays: { status: 2 }, user_id: tutor_selected.id).map{|s| s.created_at.to_date}
      else
        MockEssayFeedback.includes(mock_essay: :mock_exam_essay).where(mock_exam_essays: { status: 2 }).map{|s| s.created_at.to_date }
      end

    end

    def essay_response_unmarked_dates(tutor)
      responses = EssayResponse.includes(:user, course: :staff_profiles).where('courses.expiry_date > ? AND essay_responses.status IN (?) AND essay_responses.expiry_date > ? AND users.confirmed_at IS NOT NULL', Time.zone.now.in_time_zone("Australia/Melbourne"), [0,1], Time.zone.now.in_time_zone("Australia/Melbourne")).references(:courses)
      
      if tutor.present?
        responses.where(staff_profiles: { staff_id: tutor.id }).pluck(:expiry_date)
      else
        responses.pluck(:expiry_date)
      end

    end

    def essay_response_unmarked_by_tutor_by_date(tutor)
      dates_hash = {}
      responses = EssayResponse.includes(:user, course: :staff_profiles).where('courses.expiry_date > ? AND essay_responses.status IN (?) AND essay_responses.expiry_date > ? AND users.confirmed_at IS NOT NULL', Time.zone.now.in_time_zone("Australia/Melbourne"), [0,1], Time.zone.now.in_time_zone("Australia/Melbourne")).references(:courses)
      responses.where(staff_profiles: { staff_id: tutor.id }) if tutor.present?

      responses.group_by{|r| r.expiry_date.strftime('%Y-%m-%d') }.each do |date, date_responses|
        dates_hash[date] = {}

        date_responses.group_by{|r| r.course.staff_profiles.first&.staff&.full_name }.each do |staff_name, staff_responses|
          dates_hash[date][staff_name] = staff_responses.size
        end
      end

      dates_hash
    end

    def essay_response_marked_dates(tutor)
      if tutor.present?
        EssayTutorResponse.includes(:staff_profile, :essay_response).where(staff_profiles: {staff_id: tutor.id}, essay_responses: {assessment_attempt_id: nil}).map{|e| e.created_at.to_date}
      else
        EssayTutorResponse.all.map{|e| e.created_at.to_date }
      end
    end
end
