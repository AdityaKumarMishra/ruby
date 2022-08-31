class FaqPagesController < ApplicationController
  layout :resolve_layout
  before_action :authenticate_user!, except: [:dashboard, :page_url_by_topic, :show_topic]
  before_action :set_faq_page, only: [:show, :edit, :update, :destroy]
  before_action :set_type, only: [:new, :index, :show, :edit, :update, :destroy, :show_topic, :dashboard, :create]
  before_action :enable_recommender, only: [:dashboard]
  respond_to :html

  def index
    authorize FaqPage

    @product_lines = ['gamsat', 'umat','hsc', 'vce']
    @array_hash_of_topics = []
    @product_lines.each do |type|
      faq_topic = FaqTopic.for_type(type)
      @array_hash_of_topics << {type => FaqPage.where(:faq_topic => faq_topic)}
    end
  end

  def show
    respond_with(@faq_page)
  end

  def new
    @faq_page = FaqPage.new
    authorize @faq_page
    respond_with(@faq_page)
  end

  def edit
    authorize @faq_page
  end

  def create
    @faq_page = FaqPage.new(faq_page_params)
    authorize @faq_page
    @faq_page.save
    respond_with(@faq_type.to_sym, :admin, @faq_page)
  end

  def update
    @faq_page.update(faq_page_params)
    authorize @faq_page
    redirect_to faq_topic_path(topic: @faq_page.faq_topic.slug )
    # respond_with(@faq_type.to_sym, :admin, @faq_page)
  end

  def destroy
    @faq_page.destroy
    authorize @faq_page
    respond_with(@faq_type.to_sym, :admin, :faq_pages)
  end

  def dashboard
    if params["type"] == "umat"
      @announcement = get_announcement('UmatReady')
      @announcement_url = get_announcement_url('UmatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('UmatReady')
      end
    elsif params["type"] == "gamsat"
      @announcement = get_announcement('GamsatReady')
      @announcement_url = get_announcement_url('GamsatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('GamsatReady')
      end
    end
    raise 'Faq not Found' if params[:type].nil?
    case @faq_topic.first.faq_type.to_sym
      when :gamsat
        @icons = gamsat_icons
        render 'faq_pages/gamsat-faq'
      when :umat
        @icons = umat_icons
        render 'faq_pages/umat-faq'
      when :vce
        @icons = vce_icons
        render 'faq_pages/vce-faq'
      when :hsc
        @icons = hsc_icons
        render 'faq_pages/hsc-faq'
      else
        raise 'Faq not Found'
    end
  end

  def show_topic
    if params["type"] == "umat"
      @announcement = get_announcement('UmatReady')
      @announcement_url = get_announcement_url('UmatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('UmatReady')
      end
    elsif params["type"] == "gamsat"
      @announcement = get_announcement('GamsatReady')
      @announcement_url = get_announcement_url('GamsatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('GamsatReady')
      end
    end
    @faq_topic = @faq_topic.friendly.find_by(slug: params[:topic])
    @faq_page = @faq_topic.faq_page if @faq_topic.present?
    if @faq_page.present?
      case @faq_page.type
        when :gamsat
          @icons = gamsat_icons
          @header_class = 'green'
        when :umat
          @icons = umat_icons
          @header_class = 'ng-binding'
        when :vce
          @icons = vce_icons
          @header_class = 'purple'
        when :hsc
          @icons = hsc_icons
          @header_class = 'red'
        else
          raise 'Faq not Found'
      end
    else
      flash[:notice] = 'Faq not found'
      redirect_to root_path
    end
  end

  def page_url_by_topic
    faq_topic = FaqTopic.find params[:topic_id]
    render json: nil if faq_topic.nil?

    page = FaqPage.find_by_faq_topic_id(faq_topic.id)
    if page.nil?
      page = FaqPage.create!(:topic => faq_topic)
    end
    # render json: url_for controller: 'faq_pages', action: 'edit', type:@faq_type, id:page.id }
    render json: url_for([:edit, params[:type].to_sym, :admin, page])
  end

  def page_url_by_product_line
    render json: url_for([:index, params[:type], :admin, page])
  end


  private
    def set_faq_page
      @faq_page = FaqPage.find_by(id: params[:id])
      unless [:manager, :admin, :superadmin].include? current_user.role.to_sym
        if ['gamsat', 'umat'].include? @faq_page.faq_topic.faq_type
          raise ActiveRecord::RecordNotFound
        end
      end
    end

    def faq_page_params
      params.require(:faq_page).permit(:faq_topic_id, :content)
    end

    def gamsat_icons
      {
          'understanding-gamsat' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_understanding.png',
          'preparing-gamsat' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_preparing.png',
          'about-gradready' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_about.png',
          'enrolment-payment' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_enrolment-payment.png',
          'non-science-background' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_non-science.jpg',
          'postgraduate-medical-school-admissions' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_admission.png',
      }
    end

    def umat_icons
      {
          'und_umat' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_umat_und.png',
          'eligibility' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_umat_eligibility.png',
          'preparation' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_umat_preparation.png',
          'umatready' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_umat_ready.png',
          'undergraduate' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_umat_undergraduate.png',
          'enrolment' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_umat_enrolment.png',
      }
    end

    def vce_icons
      {
          'und_vce' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_vce_und.png',
          'preparation' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_vce_preparing.png',
          'vceready' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_vce_about.png',
          'enrolment' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_vce_enrol.png',
          'university-admissions' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_vce_admissions.png'
      }
    end

    def hsc_icons
      {
        'und_hsc' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_hsc_und.png',
        'preparation' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_hsc_preparing.png',
        'hscready' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_hsc_about.png',
        'enrolment' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_hsc_enrol.png',
        'university-admissions' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_hsc_admissions.png'
      }
    end

    def set_type
      params[:type]="gamsat" if params[:type].present? && params[:type]=="gamsat-preparation-courses"
      params[:type]="umat" if params[:type].present? && params[:type]=="umat-preparation-courses"
      raise 'Faq type not Found' if !FaqTopic.faq_types.has_key? params[:type]
      @faq_type = params[:type]
      @faq_topic = FaqTopic.for_type(@faq_type)
    end

    def enable_recommender
      @show_course_recommender = true
    end

    def resolve_layout
      action_name == 'show_topic' || action_name == 'dashboard' ? 'public_page' : 'dashboard'
    end
end
