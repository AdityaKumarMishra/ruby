class ExamSectionsController < ApplicationController
  layout "layouts/dashboard"
  before_action :set_exam_section, only: [:show, :edit, :update,
    :destroy, :delete_mcqs]

  respond_to :html

  def index
    @exam_sections = ExamSection.all
    respond_with(@exam_sections)
  end

  def show
    respond_with(@exam_section)
  end

  def new
    @exam_section = ExamSection.new
    set_free_mcqs
    respond_with(@exam_section)
  end

  def edit
    set_free_mcqs
  end

  def create
    @exam_section = ExamSection.new(exam_section_params)
    if @exam_section.save
      mcqs_to_exam_section(@exam_section.mcqs)
    else
      set_free_mcqs
    end
    respond_with(@exam_section)
  end

  def update
    if @exam_section.update(exam_section_params)
      mcqs_to_exam_section(@exam_section.mcqs)
    else
      set_free_mcqs
    end
    respond_with(@exam_section)
  end

  def destroy
    @exam_section.destroy
    respond_with(@exam_section)
  end

  def delete_mcqs
    mcqs_to_delete = []
    mcqs_to_exam_section(mcqs_to_delete)
    set_free_mcqs unless @exam_section.mcqs.delete(mcqs_to_delete)
    respond_with(@exam_section)
  end

  private
    def mcqs_to_exam_section(array)
      if params[:exam_section][:mcqs].present?
        params[:exam_section][:mcqs].reject(&:empty?).each do |mcq|
          array << Mcq.find(mcq.to_i)
        end
      end
    end

    def set_free_mcqs
      @mcqs = Mcq.no_exam_section
    end

    def set_exam_section
      @exam_section = ExamSection.friendly.find(params[:id])
    end

    def exam_section_params
      params.require(:exam_section).permit(:title, :dificultyRating)
    end
end
