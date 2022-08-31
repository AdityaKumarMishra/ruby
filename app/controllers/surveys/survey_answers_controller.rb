class Surveys::SurveyAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_surveys_survey_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @surveys_survey_answers = Surveys::SurveyAnswer.all
    respond_with(@surveys_survey_answers)
  end

  def show
    respond_with(@surveys_survey_answer)
  end

  def new
    @surveys_survey_answer = Surveys::SurveyAnswer.new
    respond_with(@surveys_survey_answer)
  end

  def edit
  end

  def create
    @surveys_survey_answer = Surveys::SurveyAnswer.new(surveys_survey_answer_params)
    @surveys_survey_answer.save
    respond_with(@surveys_survey_answer)
  end

  def update
    @surveys_survey_answer.update(surveys_survey_answer_params)
    respond_with(@surveys_survey_answer)
  end

  def destroy
    @surveys_survey_answer.destroy
    respond_with(@surveys_survey_answer)
  end

  private
    def set_surveys_survey_answer
      @surveys_survey_answer = Surveys::SurveyAnswer.find(params[:id])
    end

    def surveys_survey_answer_params
      params.require(:surveys_survey_answer).permit(:user_id, :survey_question_id, :answer, :rating)
    end
end
