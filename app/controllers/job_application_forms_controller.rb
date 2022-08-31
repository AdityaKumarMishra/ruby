class JobApplicationFormsController < ApplicationController
  before_action :set_job_application_form, only: [:show, :edit, :update, :destroy, :show_available_position]
  before_action :authenticate_user!, except: [:available_positions]
  respond_to :html
  before_action :ensure_not_student!, except: [:available_positions]
  layout :resolve_layout
  def index
    @job_application_forms = JobApplicationForm.active_jobs
    @filterrific = initialize_filterrific(
        @job_application_forms,
        params[:filterrific],
        select_options: {
          with_open: ['True', 'False']
        }
    ) or return
    @job_application_forms = @filterrific.find.paginate(page: params[:page], per_page: 20)
  end

  def show
  end

  def new
    @job_application_form = JobApplicationForm.build_new
  end

  def edit
    @job_application_form.validate_attachments
  end

  def create
    @job_application_form = JobApplicationForm.new(job_application_form_params)
    @job_application_form.validate_attachments
    respond_to do |format|
      if @job_application_form.save
        format.html { redirect_to job_application_forms_path, notice: 'Job application form was successfully created.' }
        format.json { render :show, status: :created, location: @job_application_form }
      else
        format.html { render :new }
        format.json { render json: @job_application_form.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    respond_to do |format|
      if @job_application_form.update(job_application_form_params)
        format.html { redirect_to job_application_forms_path, notice: 'Job application form was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_application_form }
      else
        format.html { render :edit }
        format.json { render json: { message: 'Something went wrong' }, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @job_application_form.destroy
    respond_to do |format|
      format.html { redirect_to job_application_forms_url, notice: 'Job application form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def available_positions
    @available_positions = JobApplicationForm.where(open: true)
  end

  def show_available_position
  end

  def archived_jobs
    @job_application_forms = JobApplicationForm.archived_jobs
    @filterrific = initialize_filterrific(
        @job_application_forms,
        params[:filterrific],
        select_options: {
          with_open: ['True', 'False']
        }
    ) or return
    @job_application_forms = @filterrific.find.paginate(page: params[:page], per_page: 20)
  end

  private

  def resolve_layout
    action_name == 'available_positions' ? 'public_page' : 'dashboard'
  end
  def ensure_not_student!
    # :ensure_not_student! should be replaced by properly using permission management gems

    # If redirected, the action is not run.
    redirect_to dashboard_home_path if current_user.nil? or current_user.student?
  end

  def set_job_application_form

    if(params[:job_id].present?)
      @job_application_form = JobApplicationForm.find(params[:job_id])
    else
      @job_application_form = JobApplicationForm.friendly.find(params[:id])
    end
  end

  def job_application_form_params
    params.require(:job_application_form).permit(:title, :description, :open, job_description_attributes: [ :id, :document ],
                                                 application_questions_attributes: [ :id, :content, :answer_type, :_destroy,
                                                     answer_options_attributes: [ :id, :content, :_destroy ] ] )
  end

end
