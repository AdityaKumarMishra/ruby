class CourseVersionsController < ApplicationController
  before_action :set_course_version, only: [:show, :edit, :update, :destroy, :sign_on_course, :sign_out_from_course]
  before_action :set_course, except:  [:sign_on_course, :sign_user_on_course,:sign_out_from_course]
  before_action :authenticate_user!, only: [:sign_on_course]
  before_action :not_authorised_user, only: [:sign_user_on_course]



  # GET /course_versions
  # GET /course_versions.json
  def index
    @course_versions = @course.course_versions
  end

  # GET /course_versions/1
  # GET /course_versions/1.json
  def show
    @address = @course_version.address
  end

  # GET /course_versions/new
  def new
    @course_version = CourseVersion.new
    @address = Address.new
    @course_version.address = @address
    @address.addresable = @course_version
  end

  # GET /course_versions/1/edit
  def edit
  end

  # POST /course_versions
  # POST /course_versions.json
  def create
    @course_version = CourseVersion.new(course_version_params)
    @course_version.course = @course
    respond_to do |format|
      if @course_version.save
        format.html { redirect_to course_course_version_path(@course,@course_version), notice: 'Course version was successfully created.' }
        format.json { render :show, status: :created, location: @course_version }
      else
        format.html { render :new }
        format.json { render json: @course_version.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # PATCH/PUT /course_versions/1
  # PATCH/PUT /course_versions/1.json
  def update
    respond_to do |format|
      if @course_version.update(course_version_params)
        format.html { redirect_to course_course_version_path(@course,@course_version), notice: 'Course version was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_version }
      else
        format.html { render :edit }
        format.json { render json: @course_version.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # DELETE /course_versions/1
  # DELETE /course_versions/1.json
  def destroy
    @course_version.destroy
    respond_to do |format|
      format.html { redirect_to course_course_versions_url(@course), notice: 'Course version was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sign_on_course
    result = @course_version.sign_in current_user
    if result[:status]
      redirect_to course_course_version_url(@course_version.course, @course_version), notice: result[:msg]
    else
      redirect_to course_course_version_url(@course_version.course, @course_version), alert: result[:msg]
    end
  end

  def sign_user_on_course
    result = @course_version.sign_in params[:user_id]
    if result[:status]
      redirect_to course_course_version_url(@course_version.course, @course_version), notice: result[:msg]
    else
      redirect_to course_course_version_url(@course_version.course, @course_version), alert: result[:msg]
    end
  end

  def sign_out_from_course

    if @course_version.sign_out current_user
      redirect_to course_course_versions_path(@course_version.course), notice: 'Sign out'
    else
      redirect_to course_course_versions_path(@course_version.course), notice: 'Not Sign out'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_version
      @course_version = CourseVersion.find(params[:id])
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_version_params
      params.require(:course_version).permit(:version_number, :date_added, :class_size, :expiry_date,
                                             :enrolment_end_added, :students_count,
                                             address_attributes: [:number,:street_name,:street_type,:subburb,:city,
                                                                  :post_code,:state,:country])
    end
end
