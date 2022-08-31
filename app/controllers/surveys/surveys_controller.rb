class Surveys::SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_surveys_survey, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @surveys_surveys = Surveys::Survey.all
    respond_with(@surveys_surveys)
  end

  def show
    respond_with(@surveys_survey)
  end

  def new
    @surveys_survey = Surveys::Survey.new
    respond_with(@surveys_survey)
  end

  def edit
  end

  def create
    @surveys_survey = Surveys::Survey.new(surveys_survey_params)
    @surveys_survey.save
    respond_with(@surveys_survey)
  end

  def update
    @surveys_survey.update(surveys_survey_params)
    respond_with(@surveys_survey)
  end

  def destroy
    @surveys_survey.destroy
    respond_with(@surveys_survey)
  end

  def fill
    @surveys_survey = Surveys::Survey.friendly.find(params[:survey_id])
  end

  def filled
    @surveys_survey = Surveys::Survey.friendly.find(params[:survey_id])

    respond_to do |format|
      answers = params[:filled_survey]

      begin
        @surveys_survey.transaction do
          @surveys_survey.survey_questions.each { |question|
            unless answers[question.answer_input_html_name].blank?
              question.survey_answers.create(
                :answer => answers[question.answer_input_html_name],
                :user => current_user) unless question.is_answered?(current_user)
            end
            format.html {
              @surveys_survey.user_survey(current_user).update_columns(:is_submited => true)
              redirect_to dashboard_path, notice: 'Thank you for your answers.'
            }
            format.json { render :show, status: :created, location: @surveys_survey }
          }
        end
      # rescue StandardError => ex
      #   ex
      #   format.html { redirect_to dashboard_path, notice: 'There has been an error.' }
      #   format.json { render json: 'There has been an error.', status: :unprocessable_entity }
      end
    end
  end

  private
    def set_surveys_survey
      @surveys_survey = Surveys::Survey.friendly.find(params[:id])
    end

    def surveys_survey_params
      params.require(:surveys_survey).permit(:title, :date_published, :date_start, :published, :date_closed, :user_ids => [])
    end
end
