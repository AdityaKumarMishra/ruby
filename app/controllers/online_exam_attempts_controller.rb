class OnlineExamAttemptsController < ApplicationController
  layout 'layouts/mathjax'
  layout "layouts/student_page"
  before_action :authenticate_user!
  before_action :set_online_exam_attempt, only: [:show, :edit, :update, :destroy]
  before_action :check_access_limit, only: [:create]
  before_action :delete_stats, only: [:show]

  def index
    if current_user.student? && !current_user.questionnaire.present?
      current_user.update_feature_access_count
      redirect_to dashboard_home_path(update_background: true) and return if current_user.feature_access_count > 3
    end
    master_feature = current_user.accessible_features.where.not("name ILIKE ?", "%MockExamFeature").where("name ILIKE ?", "%ExamFeature").first
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end

    @exam_purchase_qty = 0
    exam_features = current_user.active_enrolment_features.includes(:master_feature).where('master_features.name LIKE ? AND master_features.name NOT LIKE ?', '%ExamFeature%', '%Live%').where.not(qty: nil)

    @exam_purchase_qty = exam_features.map do |ef|
      ef.product_version_feature_price.qty
    end.sum if exam_features.present?

    course_tag_ids = current_user.current_course_tags.collect{|t| t.id}
    added_feature_log_exams = current_user.online_exam_feature.where.not(exam_name: nil)
    default_feature_log_exams = current_user.online_exam_feature.where(exam_name: nil)
    added_exams = OnlineExam.where(title: added_feature_log_exams.pluck(:exam_name))
    qty = @exam_purchase_qty
    @online_exam_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids }, online_exams:{published: true}).order("online_exams.title")
    user_exam_attempt_ids = @online_exam_attempts.pluck(:assessable_id)

    qty = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).count if qty.zero?
    if qty.present? && qty >= @online_exam_attempts.count
      @online_exams = policy_scope(OnlineExam).order(:position).limit(qty)
      ids = @online_exams.map(&:id)
      if (ids & @online_exam_attempts.map{|e| e.assessable.id }).blank?
        @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).order(:position).limit(qty)
      else
        @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).order(:position).limit(qty - @online_exam_attempts.count)
      end
    else
      @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).order(:position)
    end
    @online_exams = policy_scope(OnlineExam).where.not(id: user_exam_attempt_ids).where(position: nil) + @online_exams + added_exams
    @remaining_online_exams = policy_scope(OnlineExam).where.not(id: @online_exams.map(&:id) + @online_exam_attempts.pluck(:assessable_id)).order(:position)
    @online_exams = OnlineExam.where(id: @online_exams.map(&:id)).where.not(id: user_exam_attempt_ids).order("position ASC NULLS LAST") if @online_exams.present?

    authorize(@online_exam_attempts, :online_exams_index?)
    @online_exam_attempt = current_user.online_exam_attempts.new
    @access = params[:access]
    if @access
      course_type = current_course.product_version.try(:type)
      case course_type
      when 'GamsatReady'
        @p_course_path = '/gamsat-preparation-courses#course-packages'
        @product_line = 'GAMSAT'
      when 'UmatReady'
        @p_course_path = '/umat-preparation-courses#course-packages'
        @product_line = 'UMAT'
      when 'HscReady'
        @p_course_path = '/hsc'
        @product_line = 'HSC'
      when 'VceReady'
        @p_course_path = '/vce'
        @product_line = 'VCE'
      end
    end
  end

  def show
    if @online_exam_attempt.course_id != current_course.try(:id)
      redirect_to online_exam_attempts_path
    end
  end

  def print_exam_questions
    @current_course = current_user.active_course
    master_feature = current_user.accessible_features.find_by("title = 'Exams' AND name LIKE?", '%ExamFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    online_exam_attempt = current_user.online_exam_attempts.find_by(assessable_id: params[:id], course_id: current_course.id)
    @online_exam_attempt = online_exam_attempt.nil? ? current_user.online_exam_attempts.new : online_exam_attempt


    if online_exam_attempt.nil?
      @online_exam_attempt.assessable_id = params[:id]
      @online_exam_attempt.assessable_type = "OnlineExam"
      @online_exam_attempt.attempt_mode = 1
      @online_exam_attempt.course_id = @current_course.id
      @online_exam_attempt.save
    end

    generate_and_save_document(@online_exam_attempt)
    @sections = @online_exam_attempt.section_attempts.includes(:section).order("sections.title desc")
    @online_exam = policy_scope(OnlineExam).find(params[:id])
    @print = OnlineExamPrint.find_by(user_id: current_user.id, online_exam_id: @online_exam.id)
    @print_count = @print.print_count if @print
  end

  def print_count
    user_id = current_user.id
    ol_id = params[:id]
    @print = OnlineExamPrint.find_by(user_id: user_id, online_exam_id: ol_id)
    if @print
      @print.update(print_count: @print.print_count + 1) if current_user.student?
    else
      @print = OnlineExamPrint.create(user_id: user_id, online_exam_id: ol_id, print_count: 1) if current_user.student?
    end
    @print
  end

  def new
    @course = current_course
    @online_exam_attempt = current_user.online_exam_attempts.new
  end

  def create_print_exam
    @online_exam = policy_scope(OnlineExam).find(online_exam_attempt_params[:assessable_id])
    exam_attempt = current_user.online_exam_attempts.find_by(assessable_id: online_exam_attempt_params[:assessable_id], course_id: current_course.id)
    if exam_attempt.nil?
      @online_exam_attempt = current_user.online_exam_attempts.new(online_exam_attempt_params)
      @online_exam_attempt.assessable_type = "OnlineExam"
      # authorize @online_exam_attempt if @online_exam_attempt.valid?
      @course = current_course
      respond_to do |format|
        if @online_exam_attempt.save
          format.html { redirect_to print_exam_questions_online_exam_attempt_path(@online_exam), notice: 'Score is successfully submitted.' }
        else
          format.html {redirect_to print_exam_questions_online_exam_attempt_path(@online_exam)}
          flash[:error] = 'Please review the problems below.'
        end
      end
    else
      exam_attempt.update(section_one_score: online_exam_attempt_params[:section_one_score], section_three_score: online_exam_attempt_params[:section_three_score] )
      sections = exam_attempt.section_attempts.includes(:section).order("sections.title desc")
      sections.first.update(mark: online_exam_attempt_params[:section_one_score], completed_at: Time.zone.now) unless online_exam_attempt_params[:section_one_score].to_i.zero?
      sections.last.update(mark: online_exam_attempt_params[:section_three_score], completed_at: Time.zone.now) unless online_exam_attempt_params[:section_three_score].to_i.zero?
      exam_attempt.update_mark
      redirect_to print_exam_questions_online_exam_attempt_path(@online_exam), notice: 'Score is successfully submitted.'
    end
  end

  def generate_and_save_document(online_exam_attempt)
    online_exam = online_exam_attempt.assessable
    section_attempts = online_exam_attempt.section_attempts.includes(:section).order("sections.title DESC")
    the_pdf = WickedPdf.new.pdf_from_string(render_to_string(
        template: 'online_exam_attempts/generate_document.pdf.html.haml',
        locals:{
          section_attempts: section_attempts,
        },
         :layout => 'pdf.html.haml'
      ),
      pdf: online_exam.id,
      header: {
        content: render_to_string(
          'online_exam_attempts/pdf_header',
          layout: 'pdf.html.haml'
        )
      },
      footer: {
        content: render_to_string(
          'online_exam_attempts/pdf_footer',
          layout: 'pdf.html.haml'
        )
      },
      handlers: [:haml],
      formats: [:html],
      layout: false,
      encoding: 'UTF-8',
      disposition: 'attachment'
    )
    online_exam.document = StringIO.new(the_pdf)
    online_exam.save!
  end

  def create
    @online_exam_attempt = current_user.online_exam_attempts.new(online_exam_attempt_params)
    @online_exam_attempt.assessable_type = "OnlineExam"
    authorize @online_exam_attempt if @online_exam_attempt.valid?
    @course = current_course
    respond_to do |format|
      if @online_exam_attempt.save
        format.html { redirect_to online_exam_attempt_path(@online_exam_attempt), notice: 'Online exam attempt was successfully created.' }
        format.json { render :show, status: :created, location: @online_exam_attempt }
      else
        format.html { render :new }
        format.json { render json: @online_exam_attempt.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @online_exam_attempt.destroy
    respond_to do |format|
      format.html { redirect_to online_exam_attempts_url, notice: 'Online exam attempt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_online_exam_attempt
    @online_exam_attempt = AssessmentAttempt.find(params[:id])
    authorize @online_exam_attempt
  end

  def online_exam_attempt_params
    params.require(:assessment_attempt).permit(:course_id, :assessable_id, :question_style, :timer_option_type, :attempt_mode, :section_one_score, :section_three_score, :section_type)
  end

  def check_access_limit
    return unless current_user.student?
    redirect_to dashboard_home_path(update_background: true) and return if !current_user.questionnaire.present?
    access_feature = current_user.active_enrolment_features.includes(:master_feature).where('master_features.name LIKE (?) AND master_features.name NOT LIKE (?)', '%ExamFeature%', '%Live%')
    return if access_feature.where(qty: nil).present?
    access_limit = access_feature.sum(:qty)
    return if access_limit <= 0
    course_tag_ids = current_user.current_course_tags.map(&:id)
    online_exam_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids }).order("online_exams.title")
    exams_count = online_exam_attempts.count
    if (access_limit <= exams_count)
      redirect_to online_exam_attempts_path(access: false)
    end
  end

  def delete_stats
    # if current_user.stats_deleted_at < Date.today
    #   if current_user.exam_statistics.present?
        current_user.exam_statistics.destroy_all
      #   current_user.update(stats_deleted_at: Date.today)
      # end
    # end
  end
end
