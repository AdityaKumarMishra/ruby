class AnnouncementsController < DashboardController
  before_action :authenticate_user!
  before_action :set_product_line, only: [:new, :index]
  before_action :set_pending_features, only: [:new, :index]
  before_action :set_pending_main, only: [:new, :index]
  before_action :set_pending_home_page, only: [:new, :index]
  before_action :set_pending_product_line, only: [:new, :index]
  before_action :set_announcement, only: [:show, :edit, :update, :destroy], except: [:search]
  before_action :check_admin, only: [:index, :edit, :new, :destroy, :create]

  def index
    @announcements = Announcement.all
    # init all default announcements that have yet to be made
    @all_pending_announcements = []
    @filterrific = initialize_filterrific(
        @announcements,
        params[:filterrific],
        select_options: {
          by_product_line: ['All', 'Gamsat', 'Umat', 'Vce', 'Hsc']
        },
        :persistence_id => false,
    ) or return
    @all_announcements = @filterrific.find.paginate(page: params[:page], per_page: 20).order(:name)
    if (params[:filterrific].present? && params[:filterrific][:by_product_line] == "All") || !params[:filterrific].present?
      add_announcement_by_category(@all_pending_announcements, 'Homepage', set_pending_product_line)
      add_announcement_by_category(@all_pending_announcements, 'Homepage', @home_page)
      add_announcement_by_category(@all_pending_announcements, 'Dashboardpage', set_dashboard_announcement)
    end
  end

  def new
    @announcement = Announcement.new
    pending_announcement = params[:name]
    # if there is no pending announcement
    # new announcement is set default for product version
    if pending_announcement.nil?
      @category = 'product version'
    else
      @name = pending_announcement['value']
      @category = pending_announcement['category']
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
    @type = @announcement.product_line.name.titleize + 'Ready' if @announcement.product_line
    @name = @announcement.name
    @category = params[:category]
  end

  def create
    @announcement = Announcement.new(announcement_params)
    respond_to do |format|
      if @announcement.save
        format.html { redirect_to announcements_path, notice: 'Announcement was successfully created.' }
      else
        product_line = ProductLine.find_by(id: @announcement.product_line_id)
        @type = product_line.name.titleize + 'Ready' if product_line
        format.html { render :new }
      end
    end
  end

  def destroy
    announcement = Announcement.find(params[:id])
    announcement.destroy
    respond_with(:announcements)
  end

  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to announcements_path, notice: 'Announcement was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def get_versions_and_features
    product_line = ProductLine.find_by(id: params[:product_line_id])
    if product_line.present?
      created_feature_ids = product_line.announcements.pluck(:master_feature_id)
      type = product_line.name.titleize + 'Ready'
      @master_features = MasterFeature.includes(:product_versions).where.not(id: created_feature_ids).where(product_versions: { id: ProductVersion.where(type: type).ids}).uniq
    end
  end

  private
    def announcement_params
      params.require(:announcement).permit(:name, :category, :description, :url, :highlighted_text, :product_line_id, :master_feature_id, :show_highlight, :display_name, :story, :video)
    end

    def add_announcement_by_category(announcements, category, category_specific_announcement)
      return if category_specific_announcement.nil?
      category_specific_announcement.each do |category_announcements|
        announcements << {'category' => category, 'value' => category_announcements}
      end
    end

    def get_product_versions_slugs
      slugs = Array.new
      product_versions = ProductVersion.all
      product_versions.each do |product|
        slugs << product.slug
      end
      return slugs
    end

    def get_product_versions_names
      names = Array.new
      product_versions = ProductVersion.all
      product_versions.each do |product|
        names << product.name
      end
    end

    def get_product_version_type_hashes
      new_hash = []
      product_types = ['GamsatReady', 'UmatReady', 'VceReady', 'HscReady']
      product_types.each do |type|
        product_versions = ProductVersion.where(type: type)
        names = [['All', nil]]
        product_versions.each do |product|
          names << [product.name, product.id]
        end
        new_hash << {type => names}
      end
      return new_hash
    end

    # Return a list of announcements name pending to be made
    def get_pending_announcements(expected, data)
    end

    # Return a list of feature announcements that're yet to be made
    def set_pending_features
      @features = [
        'Diagnostic Assessment',
        'Videos',
        'MCQs',
        'Textbooks',
        'Exams',
        'Documents',
        'Book Tutor',
        'Essay Responses',
      ]
      # if any of them exists in database, assign to array for pending delete
      features_to_delete = []
      @features.each do |feature|
        saved_feature_announcement = Announcement.find_by(name: feature)
        if !saved_feature_announcement.nil?
          features_to_delete << feature
        end
      end
      # remove from list
      features_to_delete.each do |feature_to_delete|
        @features.delete(feature_to_delete)
      end
    end

    def set_pending_main
      main = 'Courses'
      main_announcement = Announcement.find_by(name: main)
      if main_announcement.nil?
        @main = ['Courses']
      end
    end

    def set_pending_home_page
      home_announcement = Announcement.find_by(name: 'Homepage')
      if home_announcement.nil?
        @home_page = ['Homepage']
      end
    end

    # Set product lines array, and return a new duplicate for use
    def set_product_line
      @product_lines = ['GamsatReady', 'UmatReady', 'VceReady', 'HscReady']
      return ['GamsatReady', 'UmatReady', 'VceReady', 'HscReady']
    end

    def set_announcement
      @announcement = Announcement.find(params[:id])
      # authorize @announcement
    end

    def set_pending_product_line
      product_lines = set_product_line
      products_to_delete = []
      product_lines.each do |product|
        saved_product_announcement = Announcement.find_by(name: product)
        if !saved_product_announcement.nil?
          products_to_delete << product
        end
      end
      # remove from list
      products_to_delete.each do |product_to_delete|
        product_lines.delete(product_to_delete)
      end
      return product_lines
    end

    def set_dashboard_announcement
      dashboard_announcements = ['GamsatReady-dashboard', 'UmatReady-dashboard', 'HscReadyEnglish-dashboard', 'HscReadyMath-dashboard', 'VceReadyEnglish-dashboard', 'VceReadyMath-dashboard']
      products_to_delete = []
      dashboard_announcements.each do |product|
        saved_product_announcement = Announcement.find_by(name: product)
        if !saved_product_announcement.nil?
          products_to_delete << product
        end
      end
      # remove from list
      products_to_delete.each do |product_to_delete|
        dashboard_announcements.delete(product_to_delete)
      end
      return dashboard_announcements
    end

    def check_admin
      redirect_to root_path and return if current_user.student?
    end
end
