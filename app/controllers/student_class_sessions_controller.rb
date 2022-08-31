class StudentClassSessionsController < ApplicationController
  before_action :set_student_class_session, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @student_class_sessions = StudentClassSession.all
    respond_with(@student_class_sessions)
  end

  def show
    respond_with(@student_class_session)
  end

  def new
    @student_class_session = StudentClassSession.new
    respond_with(@student_class_session)
  end

  def edit
  end

  def create
    @student_class_session = StudentClassSession.new(student_class_session_params)
    @student_class_session.save
    respond_with(@student_class_session)
  end

  def update
    @student_class_session.update(student_class_session_params)
    respond_with(@student_class_session)
  end

  def destroy
    @student_class_session.destroy
    respond_with(@student_class_session)
  end

  private
    def set_student_class_session
      @student_class_session = StudentClassSession.find(params[:id])
    end

    def student_class_session_params
      params.require(:student_class_session).permit(:start_time, :end_time, :frequency, :student_class_id)
    end
end
