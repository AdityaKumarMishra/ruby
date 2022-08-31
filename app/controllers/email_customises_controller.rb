class EmailCustomisesController < ApplicationController
	before_action :authenticate_user!
  before_action :courses, only: [:new, :edit]
	layout 'layouts/dashboard'

  def new
  	@custom_email = EmailCustomise.new
    @product_versions = ProductVersion.where(product_line: 1).order(:name)
    # @filterrific_pv = initialize_filterrific(
    #     @product_versions,
    #     params[:filterrific],
    #     select_options: {
    #       by_product_line: ["HscReady", "VceReady", "GamsatReady", "UmatReady"]
    #     }
    # ) or return
    # @product_versions = @filterrific_pv.find.order(:name)
  end	

  def create
  	@custom_email = EmailCustomise.new(email_customise_params)
    respond_to do |format|
      if @custom_email.save
        format.html { redirect_to email_customises_path, notice: 'Email Template was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @custom_email.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def index
  	@custom_emails = EmailCustomise.all.order('created_at DESC')
  end

  def edit
    @product_versions = ProductVersion.where(product_line: 1).order(:name)
  	@custom_email = EmailCustomise.find(params[:id])
  end

  def update
  	respond_to do |format|
  		@custom_email = EmailCustomise.find(params[:id])
      if @custom_email.update(email_customise_params)
        format.html { redirect_to email_customises_path, notice: 'Email Template was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @custom_email.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
  	@custom_email = EmailCustomise.find(params[:id])
  	@custom_email = @custom_email.destroy
    respond_to do |format|
      format.html { redirect_to email_customises_path, notice: 'Email Template successfully destroyed.' }
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
      @product_versions = ProductVersion.where(product_line: 1).pluck(:id)
    end
    @master_features = MasterFeature.by_product_version(@product_versions).order(:position)
    # authorize @master_features
  end

  def duplicate
    email_customise = EmailCustomise.find_by(id: params[:id])
    if email_customise.present?
      new_email = email_customise.deep_clone
      if new_email.save
        flash[:notice] = "Successfully duplicate the record"
      else
        flash[:error] = new_email.errors.full_messages.join(', ')
      end
    else
       flash[:error] = "Something went wrong. Please try again."
    end
    redirect_to email_customises_path
  end


  private

  def email_customise_params
    params[:email_customise][:product_version_ids] = params[:email_customise][:product_version_ids].reject(&:blank?) rescue []
    params[:email_customise][:course_ids] = params[:email_customise][:course_ids].reject(&:blank?) rescue []
    params[:email_customise][:master_feature_ids] = params[:email_customise][:master_feature_ids].reject(&:blank?) rescue []
    params[:email_customise][:greeting] = params[:email_customise][:greeting].reject(&:blank?).first rescue []
    params[:email_customise][:attachment_name] = nil if eval(params[:is_attachment]) && params[:email_customise][:attachment_name].blank?
    params.require(:email_customise).permit(:publish, :email_subject, :greeting, :content, :attachment_name, product_version_ids: [], course_ids: [], master_feature_ids: [])
  end

end
