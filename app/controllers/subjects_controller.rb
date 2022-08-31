class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  # GET /subjects
  # GET /subjects.json
  def index
    @subjects = Subject.includes(:course_version, :course)
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new
    @course = Course.friendly.find(params[:course_id]) if params[:course_id]
    @course_version = CourseVersion.find(params[:course_version_id]) if params[:course_version_id]
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
    @course = @subject.course if @subject.course
    @course_version = @subject.course_version if @subject.course_version
  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = Subject.new(subject_params)
    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_active_subjects
    active_subject = ActiveSubject.find(params[:id])
    course_version = active_subject.course_version
    active_subject.destroy!
    respond_to do |format|
      format.html { redirect_to course_course_version_path course_version.course, course_version, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_for_course
    @subjects = Subject.where :course_id => params[:course_id]
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:title, :description,:course_id)
    end
end
