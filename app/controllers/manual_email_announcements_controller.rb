class ManualEmailAnnouncementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_manual_email_announcement, only: [:edit, :update, :destroy]
  before_action :courses, only: [:new, :edit]
  layout 'layouts/dashboard'

  def new
    @manual_email_announcement = ManualEmailAnnouncement.new
    @product_versions = ProductVersion.where(product_line: 1).order(:name)
  end

  def create
    @manual_email_announcement = ManualEmailAnnouncement.new(manual_email_announcement_params)
    respond_to do |format|
      if @manual_email_announcement.save
        format.html { redirect_to manual_email_announcements_path, notice: 'Manual Email Template was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @manual_email_announcement.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def index
    @manual_email_announcements = ManualEmailAnnouncement.all.order('created_at DESC')
  end

  def edit
    @product_versions = ProductVersion.where(product_line: 1).order(:name)
  end

  def update
    respond_to do |format|
      if @manual_email_announcement.update(manual_email_announcement_params)
        format.html { redirect_to manual_email_announcements_path, notice: 'Manual Email Template was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @manual_email_announcement.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @manual_email_announcement.destroy
    respond_to do |format|
      format.html { redirect_to manual_email_announcements_path, notice: 'Manual Email Template successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def courses
    features
    @courses = Course.active_courses
    @filterrific = initialize_filterrific(
        @courses,
        {"by_product_line"=> "", "with_pv"=> @product_versions, "with_city"=> Course.cities.keys, "with_name"=>""}
    ) || return
    @courses = @filterrific.find.order(:name)
  end

  def features
    if params[:pv_ids].present?
      @product_versions = ProductVersion.where(id: params[:pv_ids]).pluck(:id)
    else
      @product_versions = @manual_email_announcement.try(:product_versions).present? ? @manual_email_announcement.product_versions : ProductVersion.where(product_line: 1).pluck(:id)
    end
    @master_features = MasterFeature.by_product_version(@product_versions).order(:name)
    # authorize @master_features
  end

  def duplicate
    manual_email_announcement = ManualEmailAnnouncement.find_by(id: params[:id])
    if manual_email_announcement.present?
      new_manual_email_announcement = manual_email_announcement.deep_clone
      if new_manual_email_announcement.save
        flash[:notice] = "Successfully duplicate the record"
      else
        flash[:error] = new_manual_email_announcement.errors.full_messages.join(', ')
      end
    else
       flash[:error] = "Something went wrong. Please try again."
    end
    redirect_to manual_email_announcements_path
  end

  def manually_fire_emails
    manual_email_announcement = ManualEmailAnnouncement.find_by(id: params[:id])
    if manual_email_announcement.present?
      manual_email_announcement.sending_emails
      flash[:notice] = "Manual email announcement was successfully fired."
    else
      flash[:error] = "Something went wrong. Please try again."
    end
    redirect_to manual_email_announcements_path
  end


  private

  def set_manual_email_announcement
    @manual_email_announcement = ManualEmailAnnouncement.find_by(id:params[:id])
  end

  def manual_email_announcement_params
    params[:manual_email_announcement][:product_version_ids] = params[:manual_email_announcement][:product_version_ids].reject(&:blank?) rescue []
    params[:manual_email_announcement][:course_ids] = params[:manual_email_announcement][:course_ids].reject(&:blank?) rescue []
    params[:manual_email_announcement][:master_feature_ids] = params[:manual_email_announcement][:master_feature_ids].reject(&:blank?) rescue []
    params[:manual_email_announcement][:greeting] = params[:manual_email_announcement][:greeting].reject(&:blank?).first rescue []
    params[:manual_email_announcement][:first_docuemnt] = nil if eval(params[:is_first_docuemnt]) && params[:manual_email_announcement][:first_docuemnt].blank?
    params[:manual_email_announcement][:second_docuemnt] = nil if eval(params[:is_second_docuemnt]) && params[:manual_email_announcement][:second_docuemnt].blank?
    params[:manual_email_announcement][:third_docuemnt] = nil if eval(params[:is_third_docuemnt]) && params[:manual_email_announcement][:third_docuemnt].blank?
    params.require(:manual_email_announcement).permit(:subject, :greeting, :content, :first_docuemnt, :second_docuemnt, :third_docuemnt, product_version_ids: [], course_ids: [], master_feature_ids: [])
  end
end

