class MasterFeaturesController < ApplicationController
  layout 'layouts/dashboard'
  before_action :authenticate_user!
  before_action :set_master_feature, only: [:show, :edit, :update, :destroy, :master_feature_tags]

  respond_to :html

  def index
    @master_features = MasterFeature.all.order(:position)
    authorize @master_features
    @filterrific = initialize_filterrific(
        @master_features,
        params[:filterrific],
        select_options: {
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @master_features = @filterrific.find
  end

  def show
    authorize @master_feature
    respond_with(@master_feature)
  end

  def new
    @master_feature = MasterFeature.new
    authorize @master_feature
    respond_with(@master_feature)
  end

  def edit
  end

  def create
    @master_feature = MasterFeature.new(master_feature_params)
    authorize @master_feature
    @master_feature.save
    respond_with(@master_feature)
  end

  def update
    @master_feature.update(master_feature_params)
    respond_with(@master_feature)
  end

  def destroy
    authorize(@master_feature)
    if @master_feature.destroy
      flash[:notice] = 'MasterFeature was successfully deleted.'
    else
      flash[:error] = 'Please review the problems below.'
    end
    redirect_to action: :index
  end

  def master_feature_tags
    tags = @master_feature.tags.uniq
    unless tags.present?
      tags = Tag.all
    end
    render json: { tags: tags }
  end

  private

  def set_master_feature
    @master_feature = MasterFeature.find(params[:id])
    authorize @master_feature
  end

  def master_feature_params
    params.require(:master_feature).permit(:name, :title, :url,
                                           :icon, :show_in_sidebar,
                                           :default_state, :position, types: []
                                          )
  end
end
