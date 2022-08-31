class ExamsController < ApplicationController
  layout "layouts/dashboard"
  before_action :set_exam, only: [:show, :edit, :update,
    :destroy, :delete_exam_sections]

  respond_to :html

  def index
    @exams = Exam.all
    respond_with(@exams)
  end

  def show
    respond_with(@exam)
  end

  def new
    @exam = Exam.new
    set_free_exam_sections
    respond_with(@exam)
  end

  def edit
    set_free_exam_sections
  end

  def create
    @exam = Exam.new(exam_params)
    if @exam.save
      exam_sections_to_exam(@exam.exam_sections)
    else
      set_free_exam_sections
    end
    respond_with(@exam)
  end

  def update
    if @exam.update(exam_params)
      exam_sections_to_exam(@exam.exam_sections)
    else
      set_free_exam_sections
    end
    respond_with(@exam)
  end

  def destroy
    @exam.destroy
    respond_with(@exam)
  end

  def delete_exam_sections
    exam_sections_to_delete = []
    exam_sections_to_exam(exam_sections_to_delete)
    set_free_exam_sections unless @exam.exam_sections.delete(exam_sections_to_delete)
    respond_with(@exam)
  end

  private
    def exam_sections_to_exam(array)
      if params[:exam][:exam_sections].present?
        params[:exam][:exam_sections].reject(&:empty?).each do |es|
          array << ExamSection.find(es.to_i)
        end
      end
    end

    def set_free_exam_sections
      @exam_sections = ExamSection.without_exams
    end

    def set_exam
      @exam = Exam.find(params[:id])
    end

    def exam_params
      params.require(:exam).permit(:date_started, :date_finished)
    end
end
