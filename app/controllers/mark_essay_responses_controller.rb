class MarkEssayResponsesController < ApplicationController
  layout "layouts/dashboard"
  before_action :authenticate_user!

  respond_to :html

  def new
    @mark_essay_response = MarkEssayResponse.new
    @essay_responses = Essay.responses_within_tutors_essays(current_user.id)
    respond_with(@mark_essay_response)
  end

  def create
    @mark_essay_response = MarkEssayResponse.new(mark_params)
    if @mark_essay_response.save
      respond_with(@mark_essay_response, location: marks_path)
    else
      @essay_responses = Essay.responses_within_tutors_essays(current_user.id)
      respond_with(@mark_essay_response)
    end
  end

  private
    def mark_params
      params.require(:mark_essay_response).permit(:value, :correct, :essay_response_id, :description)
    end
end
