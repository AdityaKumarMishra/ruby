class OnlineMockExamsController < ApplicationController
  layout "layouts/dashboard"
  before_action :authenticate_user!
  before_action :set_online_mock_exam, only: [:edit, :update, :destroy]

  # GET /online_exams
  # GET /online_exams.json
  def index
    authorize OnlineMockExam
    master_feature = current_user.accessible_features.find_by("name LIKE?", '%OnlineMockExamFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    @online_mock_exams = policy_scope(OnlineMockExam)
    @filterrific = initialize_filterrific(
        @online_mock_exams,
        params[:filterrific],
        select_options: {
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @online_mock_exams = @filterrific.find.paginate(page: params[:page], per_page: 10)
    @online_mock_exams = @online_mock_exams.where(published: true)

    @online_mock_exam = OnlineMockExam.find_by(id: params[:id])
    @type = params[:type]
    file_name = ''
    if @online_mock_exam.present?
      if @type == "student_statistics"
        file_name = "#{@online_mock_exam.title} - Student Statistics - #{Date.today}"
      else
        file_name = "#{@online_mock_exam.title} - MCQ Statistics - #{Date.today}"
      end
    end
    respond_to do |format|
      format.html
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="' + file_name + '.xlsx"'
      }
      format.csv { send_data OnlineMockExam.to_csv(@online_mock_exam), filename: "#{file_name}.csv" }
    end
  end


  # GET /online_exams/new
  def new
    @online_mock_exam = OnlineMockExam.new
    @online_mock_exam.online_mock_documents.build
    @online_mock_exam.build_online_mock_vod
    @online_mock_exam.online_mock_exam_sections.build
    respond_with(@online_mock_exam)
  end

  # GET /online_exams/1/edit
  def edit
    @parent_resource = @online_mock_exam
    @parent_resource.online_mock_documents.build if @parent_resource.online_mock_documents.empty?
    @parent_resource.build_online_mock_vod if @parent_resource.online_mock_vod.nil?
    @parent_resource.online_mock_exam_sections.build if @parent_resource.online_mock_exam_sections.empty?
  end

  # POST /online_exams
  # POST /online_exams.json
  def create
    @online_mock_exam = OnlineMockExam.new(online_mock_exam_params)
    authorize @online_mock_exam
    exam_count = OnlineMockExam.where(city: online_mock_exam_params[:city]).count
    @online_mock_exam.per_city_exam_count = exam_count + 1
    respond_to do |format|
      if @online_mock_exam.save
        format.html { redirect_to online_mock_exams_path, notice: 'OnlineMockExam was successfully created.' }
        format.json { render :show, status: :created, location: @online_mock_exam }
      else

        @online_mock_exam.build_online_mock_vod if @online_mock_exam.build_online_mock_vod.nil?
        @online_mock_exam.online_mock_documents.build if @online_mock_exam.online_mock_documents.empty?
        format.html { render :new }
        format.json { render json: @online_mock_exam.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # PATCH/PUT /online_exams/1
  # PATCH/PUT /online_exams/1.json
  def update
    respond_to do |format|
      if @online_mock_exam.update(online_mock_exam_params)
        # Need tobe remove from live stage 2953
        # if essay_params.dig("0", "section_type").present? && essay_params.dig("0", "section_type") == "essay"
        #   if !@online_mock_exam.essays.present?
        #     @online_mock_exam.essays.create(title: essay_params.dig("0", "essay_title1"), question: essay_params.dig("0", "essay_question1"), tutor_id: essay_params.dig("0", "staff_id"), tag_ids: essay_params.dig("0", "tag1"))
        #     @online_mock_exam.essays.create(title: essay_params.dig("0", "essay_title2"), question: essay_params.dig("0", "essay_question2"), tutor_id: essay_params.dig("0", "staff_id2"), tag_ids: essay_params.dig("0", "tag2"))
        #   else
        #     essays = @online_mock_exam.essays
        #     essays.first.update(title: essay_params.dig("0", "essay_title1"), question: essay_params.dig("0", "essay_question1"), tutor_id: essay_params.dig("0", "staff_id"), tag_ids: essay_params.dig("0", "tag1"))
        #     essays.second.update(title: essay_params.dig("0", "essay_title2"), question: essay_params.dig("0", "essay_question2"), tutor_id: essay_params.dig("0", "staff_id2"), tag_ids: essay_params.dig("0", "tag2"))
        #   end
        # end

        format.html { redirect_to edit_polymorphic_path(@online_mock_exam), notice: 'OnlineMockExam was successfully updated.' }
        format.json { render :edit, status: :ok, location: @online_mock_exam }
      else
        @online_mock_exam.build_online_mock_vod if @online_mock_exam.build_online_mock_vod.nil?
        @online_mock_exam.online_mock_documents.build if @online_mock_exam.online_mock_documents.empty?
        format.html { render :edit }
        format.json { render json: @online_mock_exam.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # DELETE /online_exams/1
  # DELETE /online_exams/1.json
  def destroy
    @online_mock_exam.destroy
    respond_to do |format|
      format.html { redirect_to online_mock_exams_url, notice: 'OnlineMockExam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def archived_online_mock_exams
    authorize OnlineMockExam
    master_feature = current_user.accessible_features.find_by("name LIKE?", '%OnlineMockExamFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    @online_mock_exams = policy_scope(OnlineMockExam)
    @filterrific = initialize_filterrific(
        @online_mock_exams,
        params[:filterrific],
        select_options: {
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @online_mock_exams = @filterrific.find.paginate(page: params[:page], per_page: 10)
    @online_mock_exams = @online_mock_exams.where(published: false)
    @online_mock_exam = OnlineMockExam.find_by(id: params[:id])
    @type = params[:type]
    file_name = ''
    if @type == "student_statistics"
      file_name = "Student Statistics - #{Date.today}"
    else
      file_name = "MCQ Statistics - #{Date.today}"
    end
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data OnlineMockExam.to_csv(@online_mock_exam, @type), filename: "#{@online_mock_exam.title} - #{file_name}.csv" }
    end
  end

  private

  def set_online_mock_exam
    @online_mock_exam = OnlineMockExam.find(params[:id])
    authorize @online_mock_exam
  end

  def online_mock_exam_params
    params[:online_mock_exam][:city] = params[:online_mock_exam][:city].to_i if params[:online_mock_exam][:city]
    params.require(:online_mock_exam).permit(:title, :city, :instruction, :published, online_mock_documents_attributes: [:id, :document, :start_date, :start_time, :end_date, :end_time, :_destroy], online_mock_vod_attributes: [:id, :video], tag_ids: [],online_mock_exam_sections_attributes: [:id,:section_type,:document,:staff_id,:essay_id, :online_exam_id,:position,:video, :start_date, :start_time, :end_date, :end_time, :essay_expire_time, :_destroy])
  end

  # def essay_params
  #   params.require(:online_mock_exam).require(:online_mock_exam_sections_attributes)
  # end
end
