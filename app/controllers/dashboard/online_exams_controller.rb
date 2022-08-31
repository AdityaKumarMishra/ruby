class Dashboard::OnlineExamsController < DashboardController
  before_action :authenticate_user!
  before_action :set_exam, only: [:show, :edit, :update,
    :destroy, :delete_exam_sections]

  respond_to :html

  def mcqs
    # OnlineExam.for_student(current_user).first.exam_sections
    # OnlineExam.for_student(u.first).first.exam_sections.first.mcqs
    # ExamSection.last.mcqs.collect {|i| i.mcq_stem_id }.uniq
    @exam = Exam.friendly.find(params[:id])
    unless OnlineExam.for_student(current_user).include?(@exam) || @exam.date_finished.present?
      redirect_to dashboard_online_exams_path, alert: "You are not authorized."
    end
    @exam_section = @exam.exam_sections.select{ |es| es.mcqs.select{ |m| m.mcq_answers.select{ |ma| ma.mcq_student_answers.select{ |msa| msa.user_id == current_user.id } } }.blank?}.sort.first
    # @exam_section = @exam.exam_sections.select{ |es| es.mcqs.not_answered_by_student(current_user)}.sort.first

    respond_with(@exam_section, layout: 'application')

    # Konrad dupa
    # session[:gradready_exams] = OnlineExam.for_student(current_user).collect { |exam| exam.id } unless session[:gradready_exams].present?
    # if session[:gradready_exams].present?
    #   section_id = session[:gradready_exams].first
    #   exam = OnlineExam.find(section_id)
    #   # session[:gradready_exam_stems] = exam.mcqs.collect {|mcq| mcq.mcq_stem_id}.uniq
    #   session[:gradready_exam_section] = exam.exam_sections.each { |es| es.mcqs.collect {|mcq| mcq.mcq_stem_id}.uniq }
    #   session[:gradready_exams].delete section_id if session[:gradready_exam_stems].empty?
    #   mcq_stems = McqStem.where(id: session[:gradready_exam_stems])
    # else
    #   return redirect_to dashboard_essays_path, alert: 'There was a problem processing.'
    # end
    # stems = mcq_stems
    # mcq_stems.first.mcqs.each do |mcq|
    #   mcq.mcq_answers.each do |answer|
    #     answer = McqStudentAnswer.where(user_id: current_user, mcq_answer_id: answer.id)
    #     is_answered = true unless answer.blank?
    #     is_answered = true unless StemStudent.where(user_id: current_user.id, mcq_stem_id: mcq_stem.first.id).empty?
    #   end
    #   stems.delete mcq if is_answered
    # end
    # @mcq_stem = stems.first



    # if session[:gradready_stems].present?
    #   mcqs = @mcq_stem.mcqs.pluck :id
    #   session[:gradready_stems].delete @mcq_stem.id
    #   if StemStudent.where(user_id: current_user.id, mcq_stem_id: @mcq_stem.id).empty?
    #     @stem_student = StemStudent.create(time_left: 120, description: @mcq_stem.description, title: @mcq_stem.title,
    #                                        mcqs: mcqs, user_id: current_user.id,
    #                                        mcq_stem_id: @mcq_stem.id)
    #
    #     @stem_student.subject = @mcq_stem.tag.subject
    #     @stem_student.tag = @mcq_stem.tag
    #     session[:gradready_stems_summary] = [] unless session[:gradready_stems_summary].present?
    #     session[:gradready_stems_summary] << @stem_student.id
    #   end
    # else
    #   redirect_to dashboard_manage_mcqs_path, alert: 'Error: The session expired.'
    # end
  end

  def save_exam_section
    if params[:mcqs].present?
      params[:mcqs][:answers].each do |a|
        if a.second[:mcq_answer_id].present?
          mcq_answer = McqAnswer.find(a.second[:mcq_answer_id].to_i).id
          time_taken = a.second[:time_taken].to_i
          time_started = a.second[:time_started]
          mcq_student_answer = McqStudentAnswer.new( time_taken: time_taken,
                                                    mcq_answer_id: mcq_answer,
                                                    user_id: current_user.id,
                                                    time_started: time_started,
                                                    time_finished: DateTime.now,
                                                    )
          mcq_student_answer.save
        end
      end
      redirect_to dashboard_online_exam_mcqs_path(id: params[:exam_id])
    else
      redirect_to dashboard_online_exams_path, alert: 'Something went wrong.'
    end
  end

  def index
    @exams = OnlineExam.for_student(current_user).sort.reverse
  end

  def show
    @exam_sections = @exam.exam_sections
    respond_with(@exam_sections, @exam, layout: 'application')
  end
  #
  # def new
  #   @exam = Exam.new
  #   set_free_exam_sections
  #   respond_with(@exam)
  # end
  #
  # def edit
  #   set_free_exam_sections
  # end
  #
  # def create
  #   @exam = Exam.new(exam_params)
  #   if @exam.save
  #     exam_sections_to_exam(@exam.exam_sections)
  #   else
  #     set_free_exam_sections
  #   end
  #   respond_with(@exam)
  # end
  #
  # def update
  #   if @exam.update(exam_params)
  #     exam_sections_to_exam(@exam.exam_sections)
  #   else
  #     set_free_exam_sections
  #   end
  #   respond_with(@exam)
  # end

  def destroy
    @exam.destroy
    respond_with(@exam)
  end

  # def delete_exam_sections
  #   exam_sections_to_delete = []
  #   exam_sections_to_exam(exam_sections_to_delete)
  #   set_free_exam_sections unless @exam.exam_sections.delete(exam_sections_to_delete)
  #   respond_with(@exam)
  # end

  private
    def exam_sections_to_exam(array)
      if params[:exam][:exam_sections].present?
        params[:exam][:exam_sections].reject(&:empty?).each do |es|
          array << ExamSection.find(es.to_i)
        end
      end
    end

    # def set_free_exam_sections
    #   @exam_sections = ExamSection.without_exams
    # end

    def set_exam
      @exam = Exam.friendly.find(params[:id])
    end

    def exam_params
      params.require(:exam).permit(:date_started, :date_finished)
    end
end
