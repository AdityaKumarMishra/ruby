class ProductVersionsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_access_allowed!, except: [:show]
  before_action :set_product_version, only: [:show, :edit, :update, :destroy, :push_in_archived, :product_version_courses, :pull_from_archived]
  before_action :set_master_features, only: [:edit,  :update]

  respond_to :html
  layout 'layouts/dashboard'

  def index
    @total_courses = Array.new
    @product_versions = ProductVersion.all
    @filterrific = initialize_filterrific(
        @product_versions,
        params[:filterrific],
        select_options: {
          by_type: ProductVersion.options_for_course_type,
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @product_versions = @filterrific.find.paginate(page: params[:page], per_page: 20)
    @product_versions = @product_versions.where(archived: nil).order(:name)
  end

  def show
    # Note the code below is due to the page being unable to work out what course it should be in due to reliance on
    # the slug and inconsistent naming conventions for the product versions
    # A serious overhaul of the courses needs to be done

    if params[:different_course].present?
      @course = Course.find_by(id: params[:course_id])
    end
    @product_version = ProductVersion.find_by(slug: params[:id])
    if ProductVersion.course_types[@product_version.course_type] == 1
      @cities = Course.where(product_version_id: @product_version.id).where('enrolment_end_date >= ? OR remain_visible=?', Time.zone.now.beginning_of_day,true).collect(&:city).uniq.compact.sort
      @cities = @cities - ["Other"]
      @first_city = current_user&.address&.city || @cities.first
      @courses = Course.where(product_version_id: @product_version.id, city: Course.cities[@first_city]).where('enrolment_end_date >= ? OR remain_visible=?', Time.zone.now.beginning_of_day,true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible}
    elsif ProductVersion.course_types[@product_version.course_type] == 0
      @other_course = @product_version.courses.where(city: Course.cities['Other']).where('enrolment_end_date >= ? AND link_with_homepage_ft = ? OR remain_visible=?', Time.zone.now.beginning_of_day,true, true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible}.first
      unless @other_course.present?
        @other_course = @product_version.courses.where('enrolment_end_date >= ? AND link_with_homepage_ft = ? OR remain_visible =?', Time.zone.now.beginning_of_day,true, true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible}.first
      end
    elsif [4,5,10,11].include?(ProductVersion.course_types[@product_version.course_type])
      @other_course = @product_version.courses.where(city: Course.cities['Other']).where('enrolment_end_date >= ? OR remain_visible=?', Time.zone.now.beginning_of_day,true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible}.first

      unless @other_course.present?
        @other_course = @product_version.courses.where('enrolment_end_date >= ? OR remain_visible=?', Time.zone.now.beginning_of_day,true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible}.first
      end
    else
      @cities = Course.where(product_version_id: @product_version.id).where('enrolment_end_date  >= ? OR remain_visible = ?', Time.zone.now.beginning_of_day, true).select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible}.collect(&:city).uniq.compact.sort
      @first_city = @cities.first
      @courses = Course.where(product_version_id: @product_version.id, city: Course.cities[@first_city]).where('enrolment_end_date >= ? OR remain_visible = ?', Time.zone.now.beginning_of_day, true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| (!p.remain_visible && !p.enrolments_full?) || p.remain_visible}
    end

    if @courses.present?
      @courses = transform_courses(@courses)
      @selected_course = @courses.first
    end

    @announcement = get_announcement(@product_version.type)
    @announcement_url = get_announcement_url(@product_version.type)
    if !@announcement_url.nil?
      @announcement_url = get_announcement_url(@product_version.type)
    end
  end

  def new
    @product_line = ProductLine.find(params[:product_line_id])
    type = "#{@product_line.name.capitalize}Ready"
    @product_version = @product_line.product_versions.new(type: type)
    if params[:course_type].present?
      @old_product_version = ProductVersion.where(type: type, course_type: params['course_type']).first
    end
    if @old_product_version.present?
      feature_ids = @old_product_version.master_features.pluck(:id).uniq
      @master_features = MasterFeature.where(id: feature_ids)
    else
      @master_features = MasterFeature.type(@product_version.type).order(:name)
    end
    if [2, 3, 9].include?(params[:course_type].to_i)
      @master_features = MasterFeature.where('name LIKE?', '%GamsatIR%')
    end

    @master_features.count.times { @product_version.product_version_feature_prices.build } if @product_version.product_version_feature_prices.empty?
  end

  def edit
  end

  def create
    params[received_hash_name][:course_type] = params[received_hash_name][:course_type].to_i
    @product_version = ProductVersion.new(product_version_params)
    @product_line = @product_version.product_line
    @master_features = MasterFeature.type(@product_version.type)
    if @product_version.save
      redirect_to product_versions_path, notice: 'Product version created successfully'
    else
      flash[:error] = 'Error while creating product version'
      render :new
    end
  end

  def update
    params[received_hash_name][:course_type] = params[received_hash_name][:course_type].to_i
    master_ids = []
    product_version_params[:product_version_feature_prices_attributes].each do |k, v|
      if v['id'].present?
        pvfp = ProductVersionFeaturePrice.find(v['id'])
        previous_val = pvfp.is_default.to_s
        previous_dan = pvfp.qty.to_s
        changed = previous_val == v["is_default"] && previous_dan == v['qty'] ? false : true
        master_ids <<  v['master_feature_id'].to_i if changed
      end

      if v['unlimited'] == '1'
        v['qty'] = '0'
      end
      next if v['id'].present?
      master_ids << v['master_feature_id'].to_i
    end

    if @product_version.update(product_version_params)
      @product_version.update_user_features(master_ids)
      #respond_with(@product_version)
      redirect_to edit_product_version_path(@product_version), notice: 'Product version updated successfully'
    else
      render :new
    end
  end

  def destroy
    if @product_version.destroy
      flash[:notice] = 'Product version was successfully deleted.'
    else
      flash[:error] = 'Please review the problems below.'
    end
    redirect_to product_versions_path
  end

  # For push in archived
  def push_in_archived
    if @product_version.present?
      @product_version.archived = true
      @product_version.save(validate: false)
      flash[:notice] = 'Product version was successfully archived.'
      redirect_to product_versions_path
    end
  end

  def pull_from_archived
    if @product_version.present?
      @product_version.archived = nil
      @product_version.save(validate: false)
      flash[:notice] = 'Product version was successfully unarchived.'
      redirect_to product_versions_path
    end
  end

  def archived_product_versions
    @total_courses = Array.new
    @product_versions = ProductVersion.all
    @filterrific = initialize_filterrific(
        @product_versions,
        params[:filterrific],
        select_options: {
          by_type: ProductVersion.options_for_course_type,
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @product_versions = @filterrific.find.paginate(page: params[:page], per_page: 20)
    @product_versions = @product_versions.where(archived: true).order(:name)
  end

  def product_version_courses
    if @product_version.present?
      courses = @product_version.courses
      @courses = courses.order(:name).paginate(page: params[:page], per_page: 20) if courses.present?
    end
  end

  private

  def received_hash_name
    (params.keys & ProductVersion.subclasses.map { |c| c.name.underscore }).first
  end

  def ensure_access_allowed!
    user_not_authorized unless [:manager, :admin, :superadmin].include? current_user.role.to_sym
  end

  def set_product_version
    params[:id] =  params[:id] == 'math-extension-1-custom' ? 'math-extension-1-cutsom' : params[:id]
    if params[:controller] == 'gamsat_readies'
      if params[:id]=="online-essentials"
        params[:id]="online-basic"
      elsif params[:id]=="online-comprehensive"
        params[:id]="online"
      elsif params[:id]=="attendance-essentials"
        params[:id]="attendence-basic"
      elsif params[:id]=="attendance-comprehensive"
        params[:id]="attendence-d4588d4f-d803-4a68-8b06-06c2af9406ee"
      elsif params[:id]=="attendance-complete-care"
        params[:id]="attendence-all"
      elsif params[:id]=="interview-attendance-comprehensive"
        params[:id]="interviewready-comprehensive"
      elsif params[:id]=="interview-attendance-essentials"
        params[:id]="interviewready-essentials"
      elsif params[:id]=="interview-online-essentials"
        params[:id]="interviewready-online-essentials"
      elsif params[:id]=="free-trial"
        params[:id]="1-week-trial"
      elsif params[:id]=="success-assured"
        params[:id]="success-assured"
      else
        params[:id]=params[:id]
      end
    elsif params[:controller] == 'umat_readies'
      if params[:id]=="online-essentials"
        params[:id]="online-basic-5e64c230-6be0-4d7d-948a-4338a900b0af"
      elsif params[:id]=="online-comprehensive"
        params[:id]="online-44383c37-9593-4bba-8be2-23f6f123ce15"
      elsif params[:id]=="attendance-essentials"
        params[:id]="umatready-attendence-essentials"
      elsif params[:id]=="attendance-comprehensive"
        params[:id]="attendence"
      elsif params[:id]=="attendance-complete-care"
        params[:id]="attendence-all-84386da2-92e7-4267-9912-f34e31a81a59"
      elsif params[:id]=="interview-comprehensive"
        params[:id]="interviewready-comprehensive"
      elsif params[:id]=="free-trial"
        params[:id]="umat-free-trial"
      elsif params[:id]=="custom"
        params[:id]="custom-5905ac7d-219c-4c96-8708-7d4655ab563c"
      else
        params[:id]=params[:id]
      end
    else
      params[:id]=params[:id]
    end
    @product_version = ProductVersion.friendly.find_by(slug: params[:id])
    unless @product_version.present?
      redirect_to root_path
    end
  end

  def update_features
    @product_version.update_features!
  end

  def set_master_features
    @product_version.set_product_line if @product_version.product_line.nil?
    @master_features = MasterFeature.type(@product_version.type)
    @product_line = @product_version.product_line
  end

  def product_version_params
    params.require(received_hash_name).permit(:name, :description, :price, :type, :product_line_id, :course_type, :freemium, :early_bird, product_version_feature_prices_attributes: [:id, :master_feature_id, :price, :qty, :is_default, :access_limit, :subtype, :unlimited, :_destroy, :tag_ids => []])
  end
end
