class UmatReadiesController < ProductVersionsController
  layout "layouts/public_page"
  before_action :enable_recommender, only: [:show]

  # def show
  #   @announcement = get_announcement('UmatReady')
  #   @announcement_url = get_announcement_url('UmatReady')
  #   if !@announcement_url.nil?
  #     @announcement_url = get_announcement_url('UmatReady')
  #   end
  # end

  private
  def enable_recommender
    @show_course_recommender = true
  end
  # def show
  #   @umat_ready = UmatReady.find_by(slug: params[:id])
  #
  #   # The features we will show are only ones that have a template
  #   @features = @umat_ready.features
  #                   .all
  #                   .to_a
  #                   .select{|f| template_exists?(f.to_partial_path(show_underscore: true))}
  #                   .sort_by(&:sort_index)
  # end
end
