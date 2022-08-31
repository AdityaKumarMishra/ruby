class MockEssayFeedbacksController < ApplicationController

  layout "layouts/dashboard"
  before_action :authenticate_user!
  before_action :set_mock_essay, only: [:create, :show]

  def index
    @mock_exam_essay = MockExamEssay.find(params[:mock_essay_id])
    @mock_essay_feedback = MockEssayFeedback.new
  end

  def create
    @mock_essay_feedback = MockEssayFeedback.new(feedback_params)
    @mock_essay_feedback.user = current_user
    @mock_essay_feedback.mock_essay=@mock_essay
    respond_to do |format|
      if @mock_essay_feedback.save
        format.html { redirect_to mock_essay_mock_essay_feedbacks_path(@mock_essay.mock_exam_essay), notice: 'We appreciate your feedback.' }
        format.json { render :show, status: :created, location: @mock_essay }
        flash[:notice] = 'MockEssayFeedback was successfully created.'
      else

        format.html { redirect_to mock_essay_mock_essay_feedbacks_path(@mock_essay.mock_exam_essay) }
        format.json { render json: @mock_essay_feedback.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def edit
    @mock_exam_essay = MockExamEssay.find(params[:mock_essay_id])
    @mock_essay_feedback = MockEssayFeedback.find(params[:id])
  end

  def update
    @mock_essay_feedback = MockEssayFeedback.find(params[:id])
    @mock_exam_essay = MockExamEssay.find(params[:mock_essay_id])
    if @mock_essay_feedback.update(feedback_params)
      redirect_to mock_essay_mock_essay_feedbacks_path(@mock_exam_essay)
      flash[:notice] = 'MockEssayFeedback was successfully updated.'
    else
      flash[:error] = 'Please review the problems below.'
      render 'edit'
    end
  end

  private

  def feedback_params
    params.require(:mock_essay_feedback).permit(:response, :id, :rating, :mock_essay_id)
  end

  def set_mock_essay
    @mock_essay = MockEssay.find(params[:mock_essay_id])
  end
end
