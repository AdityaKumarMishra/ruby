class EventDatesController < DashboardController
	before_action :authenticate_user!
  before_action :set_product_line, only: [:new, :create, :index, :edit]
  before_action :get_product_version_type_hashes, only: [:new, :create, :index, :edit]
  before_action :set_pending_product_line, only: [:new, :index]
  before_action :set_event_date, only: [:show, :edit, :update, :destroy], except: [:search]
  before_action :check_admin, only: [:index, :edit, :new, :destroy, :create]

  def index
    @events = EventDate.all
    @all_events = @events.paginate(page: params[:page], per_page: 20)
  end

  def new
    @event = EventDate.new
    @product_version_hashes =get_product_version_type_hashes
  end

  def edit
    @event = EventDate.find(params[:id])
  end

  def create
    if (params[:event_date] && (params[:event_date][:product_version_id]=="All" || params[:event_date][:product_version_id].blank?))
      params[:event_date][:product_version_id]=nil
    end
    product_version = ProductVersion.find_by(type: params[:event_date][:product_line], name: params[:event_date][:product_version_id])
    @event = EventDate.new(event_date_params)

    if !product_version.nil?
      @event.product_version_id = product_version.id
    end

    if @event.save
      respond_with(:event_dates)
    else
      render 'new'
      flash[:error] = 'Please review the problems below.'
    end
  end

  def destroy
    event = EventDate.find(params[:id])
    event.destroy
    respond_with(:event_dates)
  end

  def update
    if (params[:event_date] && (params[:event_date][:product_version_id]=="All" || params[:event_date][:product_version_id].blank?))
      params[:event_date][:product_version_id]=nil
    end
    product_version = ProductVersion.find_by(type: params[:event_date][:product_line], name: params[:event_date][:product_version_id])

    if !product_version.nil?
      params[:event_date][:product_version_id]= product_version.id
    end

    @event.update(event_date_params)
    respond_with(:event_dates)
  end

  private
    def event_date_params
      params.require(:event_date).permit(:title, :event_start_date, :event_start_time, :event_end_time, :description, :product_line, :product_version_id)
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
        names = ['All']
        product_versions.each do |product|
          names << product.name
        end
        new_hash << {type => names}
      end

      @product_version_hashes = new_hash
      return @product_version_hashes
    end


    def set_product_line
      @product_lines = ['All', 'GamsatReady', 'UmatReady', 'VceReady', 'HscReady']
      return ['All', 'GamsatReady', 'UmatReady', 'VceReady', 'HscReady']
    end

    def set_event_date
      @event = EventDate.find(params[:id])
      # authorize @event
    end

    def set_pending_product_line
      product_lines = set_product_line
      products_to_delete = []
      product_lines.each do |product|
        saved_product_event = EventDate.find_by(title: product)
        if !saved_product_event.nil?
          products_to_delete << product
        end
      end
      # remove from list
      products_to_delete.each do |product_to_delete|
        product_lines.delete(product_to_delete)
      end
      return product_lines
    end

  def check_admin
    redirect_to root_path and return if current_user.student?
  end
end
