class JobApplicationsController < ApplicationController
  before_action :set_job_application_form, except: [:update_interview_date, :search_applications, :create]
  before_action :set_job_application, only: [:show, :edit, :update, :destroy, :download]
  before_action :authenticate_user!, except: [:new, :create, :get_tag_childrens]
  layout 'layouts/public_page', only: [:new, :create]

  def index
    if request.format.xls?
      @job_applications = @job_application_form.job_applications
    else
      get_tag_childrens
      filterrify @job_application_form.job_applications.includes(:address) or return
      @job_applications = @filterrific.find.order('created_at DESC').page(params[:page])
    end

    respond_to do |format|
      format.html
      format.json
      format.js
      format.xls
    end
  end

  def search_applications
    get_tag_childrens
    filterrify JobApplication or return
    @job_applications = @filterrific.find.order('created_at DESC').page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update_interview_date
    @job_application = JobApplication.find_by(id: params[:job_id])
    @job_application.update_column(:interview_date, params[:date])
    head :ok
  end

  def filterrify(collection)
    if @tag.present?
      content_tag_options=@tag.children.map{|x| [x.name, x.name]}
    else
      content_tag_options= [['All', 'all']]
    end
    @filterrific = initialize_filterrific(
        collection,
        params[:filterrific],
        select_options: {
            sorted_by: JobApplication.options_for_sort_by,
            with_status: JobApplication.options_for_status,
            with_degree_type: JobApplication.options_for_degree_type,
            with_position: JobApplication.options_for_position,
            with_content_tag: content_tag_options,
            with_state: JobApplication.options_for_state,
            with_domestic: JobApplication.options_for_student_type
        }
    )
  end

  def show
    if @job_application.nil?
      flash[:error] = 'Job Application not found'
      redirect_to job_application_forms_path
    end
  end

  def new
    @job_application = JobApplication.build(@job_application_form)
    @job_application.build_address(country: "", state: "")
  end

  def edit
  end

  def create
    @job_application_form = JobApplicationForm.find_by_id(params[:job_application][:job_application_form_id])
    if job_application_params["degree_type"].present?
      degree_type = JobApplication.degree_types[job_application_params["degree_type"]]
      flash[:notice] = 'Please Select Valid Degree Type!'
      redirect_back fallback_location: root_path and return if degree_type.nil?
    end

    if @job_application_form.present?
      @job_application = @job_application_form.job_applications.build(job_application_params)
      @job_application.validate_attachments
      @job_application.status = JobApplication.statuses.first[0];
    else
      flash[:notice] = 'Job Application not found!'
      redirect_to :back and return
    end
    respond_to do |format|
      if @job_application.save
        if ENV['EMAIL_CONFIRMABLE'] != "false"
          JobApplicationMailer.student_job_application(@job_application).deliver_later
          JobApplicationMailer.job_application_submitted(@job_application).deliver_later
        end
        format.html { redirect_to available_positions_job_application_forms_path(applied_for: @job_application_form.title) }
        format.json { render :show, status: :created, location: @job_application }
        flash[:notice] = 'Job Application is successfully submitted!'
      else
        format.html { render :new }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def get_tag_childrens
    if params[:filterrific] && params[:filterrific][:with_position]
      params[:content]=params[:filterrific][:with_position]
    end
    if params[:content]
      if params[:content].downcase.include? "gamsat"
        @tag=Tag.find(246)
      elsif params[:content].downcase.include? "umat"
        @tag=Tag.find(30)
      elsif params[:content].downcase.include? "hsc" && "english"
        @tag=Tag.find(38)
      elsif params[:content].downcase.include? "hsc" && "maths"
        @tag=Tag.find(326)
      elsif params[:content].downcase.include? "vce" && "english"
        @tag=Tag.find(37)
      elsif params[:content].downcase.include? "vce" && "maths"
        @tag=Tag.find(325)
      else
        @tag=Tag.none
      end
    end
  end

  def update
    respond_to do |format|
      if current_user.present? && job_application_params[:notes].present?
        @job_application.attributes = job_application_params
        if @job_application.save(validate: false)
          @success = 'updated'
        else
          @success = 'failed'
        end
        format.html { render :show }
        flash[:notice] = 'Note was successfully added.'

      elsif job_application_params[:status] == '3.3 Rejected'
        if params[:send_email].present?
          if @job_application.update(job_application_params)
            @success = 'updated'
            JobApplicationMailer.rejected_job_application(@job_application).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false" && params[:send_email] == 'true'
          else
            @success = 'failed'
          end
        end
        format.js

      elsif job_application_params[:status] == '1.2 Sent Initial Assessment'
        @job_application.assessment_sender_id = current_user.id
        @job_application.assessment_sent_time = Time.zone.now.in_time_zone("Australia/Melbourne")
        if params[:send_email].present?
          if @job_application.update(job_application_params)
            JobApplicationMailer.send_initial_assessment(@job_application).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false" && params[:send_email] == 'true'
            @success = 'updated'
          else
            @success = 'failed'
          end
        end
        format.js

      elsif @job_application.update(job_application_params)
        @success = 'updated'
        format.js
        format.html { redirect_to job_application_form_job_application_path(@job_application_form.friendly_id.parameterize, @job_application), notice: 'Job application was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @job_application.destroy
    respond_to do |format|
      format.html { redirect_to job_application_form_job_applications_url, notice: 'Job application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download_all
    zip = JobApplication.zip_applications(@job_application_form.job_applications)
    filename = "#{@job_application_form.title} - Applications - #{Date.today.to_s}.zip"
    send_data(zip[:data], type: 'application/zip', filename: filename)
  end

  def download
    applications = [ @job_application ]
    zip = JobApplication.zip_applications(applications)
    send_data(zip[:data], type: 'application/zip', filename: zip[:name])
  end

  private


  # Use callbacks to share common setup or constraints between actions.
  def set_job_application
    @job_application = @job_application_form.job_applications.find_by_id(params[:id])
  end

  def set_job_application_form
    if params[:job_application] && params[:job_application][:job_application_form_id].present?
      @job_application_form = JobApplicationForm.find(params[:job_application][:job_application_form_id])
    else
      @job_application_form = JobApplicationForm.find_by(slug: params[:job_application_form_id])
      begin
        @job_application_form = JobApplicationForm.friendly.find(params[:job_application_form_id]) if !@job_application_form.present?
      rescue
        @job_application_form = nil
      end
    end

    if @job_application_form.present?
      return @job_application_form
    else
      redirect_to root_path
    end

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_application_params
    params.require(:job_application).permit(
      :name,
      :phone_number,
      :email,
      :hours_available,
      :domestic,
      :degree_type,
      :degree,
      :graduation,
      :atar,
      :wam,
      :op,
      :other_test_score,
      :status,
      :notes,
      :applicant_type,
      :assessment_sent_time,
      :assessment_sender_id,
      :gr_score,
      :full_time_exp,
      application_answers_attributes: [ :id, :application_question_id, :content_tag, :content, content: [] ],
      address_attributes: [ :id, :line_one, :suburb, :city, :post_code, :state, :country ],
      cover_letter_attributes: [ :id, :document ],
      resume_attributes: [ :id, :document ],
      application_attachments_attributes: [ :id, :document, :_destroy]
    )
  end

end
