class UserEnrolmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student

  def index
    authorize Enrolment
    @enrolments = @student.paid_with_pending_enrolments
  end

  private
    def set_student
      @student = User.friendly.find(params[:user_id])
    end
end

