class GamsatReadiesController < ProductVersionsController

  layout "layouts/public_page"
  before_action :enable_recommender, only: [:show]

  # def show
  #   @gamsat_ready = GamsatReady.find_by(slug: params[:id])
  #   @features = @gamsat_ready.features
  #                   .all
  #                   .to_a
  #                   .sort_by(&:sort_index)
  #                   # .select{|f| template_exists?(f.to_partial_path(show_underscore: true))}
  #
  # end
  private

  def enable_recommender
    @show_course_recommender = true
    @outofstock = OutOfStock.first
  end
end
