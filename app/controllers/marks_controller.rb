class MarksController < ApplicationController
  # before_action :set_mark, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  layout "layouts/dashboard"
  respond_to :html

  def index
    @marks = Mark.current_tutor(current_user).includes(:user,
      :essay_response, :mcq_student_answer)
    respond_with(@marks)
  end

  # def show
  #   respond_with(@mark)
  # end
  #
  # def new
  #   @mark = Mark.new
  #   @essay_responses = Essays::EssayResponse.all
  #   @mcq_student_answer = McqStudentAnswer.all
  #   respond_with(@mark)
  # end
  #
  # def edit
  # end
  #
  # def create
  #   @mark = Mark.new(mark_params)
  #   @mark.save
  #   respond_with(@mark)
  # end
  #
  # def update
  #   @mark.update(mark_params)
  #   respond_with(@mark)
  # end
  #
  # def destroy
  #   @mark.destroy
  #   respond_with(@mark)
  # end
  #
  # private
  #   def set_mark
  #     @mark = Mark.find(params[:id])
  #   end
  #
  #   def mark_params
  #     params.require(:mark).permit(:value, :correct, :user_id, :essay_response_id, :mcq_student_answer_id, :description)
  #   end
end
