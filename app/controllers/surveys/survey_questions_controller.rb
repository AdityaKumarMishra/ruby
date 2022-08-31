class Surveys::SurveyQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_surveys_survey_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @surveys_survey_questions = Surveys::SurveyQuestion.all
    respond_with(@surveys_survey_questions)
  end

  def show
    respond_with(@surveys_survey_question)
  end

  def new
    @surveys_survey_question = Surveys::SurveyQuestion.new
    respond_with(@surveys_survey_question)
  end

  def edit
  end

  def create
    @surveys_survey_question = Surveys::SurveyQuestion.new(surveys_survey_question_params)
    @surveys_survey_question.save
    respond_with(@surveys_survey_question)
  end

  def update
    @surveys_survey_question.update(surveys_survey_question_params)
    respond_with(@surveys_survey_question)
  end

  def destroy
    @surveys_survey_question.destroy
    respond_with(@surveys_survey_question)
  end

  private
    def set_surveys_survey_question
      @surveys_survey_question = Surveys::SurveyQuestion.find(params[:id])
    end

    def surveys_survey_question_params
      params.require(:surveys_survey_question).permit(:survey_id, :question)
    end
end
