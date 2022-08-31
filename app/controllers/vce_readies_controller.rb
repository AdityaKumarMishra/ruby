class VceReadiesController < ProductVersionsController
  layout "layouts/application"
  before_action :enable_recommender, only: [:show]

  private
  def enable_recommender
    @show_course_recommender = true
  end

end
