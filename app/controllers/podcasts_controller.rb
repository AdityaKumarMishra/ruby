class PodcastsController < ApplicationController
	layout 'layouts/public_page'
  	# before_action :authenticate_user!
  	respond_to :html, :js

  	def index
  		@podcasts = Podcast.all.order(:created_at)
  	end

  	def show
  		@podcast = Podcast.find_by(slug: params[:id])
  		unless @podcast.present?
  			redirect_to "/404"
  		end
  	end
end
