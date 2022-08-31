class OnlineExamsController < ApplicationController
  layout "layouts/dashboard"
  before_action :authenticate_user!
  before_action :set_online_exam, only: [:show, :edit, :update, :destroy, :change_lock, :duplicate]
  before_action :set_product_lines, only: %i[new edit create update show update_product_line_positions]

  # GET /online_exams
  # GET /online_exams.json
  def index
    authorize OnlineExam
    master_feature = current_user.accessible_features.where.not("name ILIKE ?", "%MockExamFeature").where("name ILIKE ?", "%ExamFeature").first
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    @online_exams = policy_scope(OnlineExam)
    @filterrific = initialize_filterrific(
        @online_exams,
        params[:filterrific],
        select_options: {
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @online_exams = @filterrific.find.paginate(page: params[:page], per_page: 10)
    @online_exams = @online_exams.where(published: true)
    @online_exam = OnlineExam.find_by(id: params[:id])
    @type = params[:type]
    file_name = ''
    if @online_exam.present?
      if @type == "student_statistics"
        file_name = "#{@online_exam.title} - Student Statistics - #{Date.today}"
      else
        file_name = "#{@online_exam.title} - MCQ Statistics - #{Date.today}"
      end
    end
    respond_to do |format|
      format.html
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="' + file_name + '.xlsx"'
      }
      format.csv { send_data OnlineExam.to_csv(@online_exam), filename: "#{file_name}.csv" }
    end

  end

  # GET /online_exams/1
  # GET /online_exams/1.json
  def show

  end


  def download
    ol = OnlineExam.find_by(id: params[:id])
      #Download the textbook from the S3 and stream it to the user
      response.headers['Content-Type'] = 'application/pdf'
      uri = URI(ol.document.url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        http.request request do |res|
          res.read_body do |chunk|
            response.stream.write chunk
          end
        end
      end
      response.stream.close
  end

  def change_show_stat
    @exam = OnlineExam.find_by(id: params[:id])
    @exam.toggle(:show_stat)
    @exam.save!
    if @exam.show_stat
      msg = 'OnlineExam Stats will show to students'
    else
      msg = 'OnlineExam Stats will not show to students'
    end
    redirect_back fallback_location: root_path, notice: msg
  end

  # For Locking the Exam
  def change_lock
    @online_exam.update_attribute(:locked, !(@online_exam.locked || false))
    if @online_exam.locked
      msg = 'OnlineExam is locked successfully!'
    else
      msg = 'OnlineExam is unlocked successfully!'
    end
    redirect_to online_exams_path, notice: msg
  end

  # GET /online_exams/new
  def new
    @online_exam = OnlineExam.new
  end

  # GET /online_exams/1/edit
  def edit
    @parent_resource = @online_exam
    @sections = policy_scope(Section).where(sectionable: @parent_resource)
  end

  # POST /online_exams
  # POST /online_exams.json
  def create
    @online_exam = OnlineExam.new(online_exam_params)
    authorize @online_exam
    respond_to do |format|
      if @online_exam.save
        format.html { redirect_to @online_exam, notice: 'OnlineExam was successfully created.' }
        format.json { render :show, status: :created, location: @online_exam }
      else
        format.html { render :new }
        format.json { render json: @online_exam.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # PATCH/PUT /online_exams/1
  # PATCH/PUT /online_exams/1.json
  def update
    respond_to do |format|
      if @online_exam.update(online_exam_params)
        format.html { redirect_to edit_polymorphic_path(@online_exam), notice: 'OnlineExam was successfully updated.' }
        format.json { render :edit, status: :ok, location: @online_exam }
      else
        format.html { render :edit }
        format.json { render json: @online_exam.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # DELETE /online_exams/1
  # DELETE /online_exams/1.json
  def destroy
    @online_exam.destroy
    respond_to do |format|
      format.html { redirect_to online_exams_url, notice: 'OnlineExam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicate
    online_exam_title = @online_exam.title + ' (copy)'
    duplicate_online_exam = OnlineExam.new(title: online_exam_title,instruction: @online_exam.instruction,
                                          published: false, is_finish: @online_exam.is_finish ,
                                          show_stat: @online_exam.show_stat,
                                          document: @online_exam.document,
                                          position: @online_exam.position
                                          )
    @online_exam.sections.each do |section|
      duplicate_online_exam.sections.new(title: section.title,duration: section.duration,
                                        position: section.position,sectionable_type: section.sectionable_type)
    end

    @online_exam.taggings.each do |tagging|
      duplicate_online_exam.taggings.new(tag_id: tagging.tag_id,taggable_id: tagging.taggable_id,
                                        taggable_type: tagging.taggable_type,
                                        exclude_taggable_id: tagging.exclude_taggable_id,
                                        exclude_taggable_type: tagging.exclude_taggable_type)
    end
    duplicate_online_exam.save
      if duplicate_online_exam.save(validate: false)
        mcq_id_arr = @online_exam.sections.map {|section| section.section_items.pluck(:mcq_id)}
        for i in 0..duplicate_online_exam.sections.count-1
          mcq_id_arr[i].each do |mcq_id|
            duplicate_online_exam.sections[i].section_items.create(mcq_id: mcq_id)
          end
        end
        duplicate_online_exam.update(locked: @online_exam.locked)
        msg = "Online Exam Duplicated"
      else
        msg = "Error in duplication"
      end
    redirect_to edit_online_exam_path(duplicate_online_exam), notice: msg
  end

  def check_position
    product_line = ProductLine.find_by(id: params[:product_line_id])
    if params[:online_exam_id].present?
      onlineExam = OnlineExam.joins(:tags).where("(title ilike ? OR tags.name ilike ?) AND position = ? AND online_exams.published = true AND online_exams.id != ?", "%#{product_line.name}%","%#{product_line.name}%", params[:position], params[:online_exam_id]).last
    else
      onlineExam = OnlineExam.where("(title ilike ? OR tags.name ilike ?) AND position = ? AND online_exams.published = true", "%#{product_line.name}%","%#{product_line.name}%", params[:position]).last
    end
    render json: {message: onlineExam.present? ? "Exam already published for #{params[:position]} position" : "Verifed Successfully, The position is not published yet!", status:  onlineExam.blank?}
  end

  def update_product_line_positions
    @product_line = ProductLine.find(params[:product_line_id].to_i)
    @online_exam = OnlineExam.find_by(id: params[:online_exam_id].to_i) || OnlineExam.new

    respond_to do |format|
      format.js
    end
  end

  def archived_online_exams
    authorize OnlineExam
    master_feature = current_user.accessible_features.where.not("name ILIKE ?", "%MockExamFeature").where("name ILIKE ?", "%ExamFeature").first
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    @online_exams = policy_scope(OnlineExam)
    @filterrific = initialize_filterrific(
        @online_exams,
        params[:filterrific],
        select_options: {
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @online_exams = @filterrific.find.paginate(page: params[:page], per_page: 10)
    @online_exams = @online_exams.where(published: false)
    @online_exam = OnlineExam.find_by(id: params[:id])
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
      format.csv { send_data OnlineExam.to_csv(@online_exam, @type), filename: "#{@online_exam.title} - #{file_name}.csv" }
    end
  end

  private

  def set_product_lines
    @product_lines = ProductLine.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_online_exam
    @online_exam = OnlineExam.find_by(id: params[:id])
    authorize @online_exam
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def online_exam_params
    params.require(:online_exam).permit(:title, :instruction, :published, :is_finish, :document,:position, :product_line_id,tag_ids: [])
  end
end
