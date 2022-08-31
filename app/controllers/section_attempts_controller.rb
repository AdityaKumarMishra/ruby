class SectionAttemptsController < ApplicationController
  layout 'layouts/mathjax'
  layout 'layouts/dashboard'
  before_action :authenticate_user!
  before_action :set_attemptable

  def index
    @section_attempts = @attemptable.section_attempts if @online_exam_attempt || @diagnostic_test
  end

  def show
    @section_attempt = @attemptable.section_attempts.find(params[:id]) if @online_exam_attempt || @diagnostic_test_attempt
  end

  private

  def set_attemptable
    if params[:online_exam_attempt_id]
      @online_exam_attempt = current_user.online_exam_attempts.find(params[
        :online_exam_attempt_id])
      @attemptable = @online_exam_attempt
    elsif params[:diagnostic_test_attempt_id]
      @diagnostic_test_attempt = current_user.diagnostic_test_attempts.find(params[
        :diagnostic_test_attempt_id])
      @attemptable = @diagnostic_test_attempt
    end
  end
end
