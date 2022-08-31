class DownloadHitCountersController < ApplicationController

	before_action :authenticate_user!
	before_action :set_download_hit_counter, only: [:edit, :update]
	before_action :check_admin, only: [:index, :edit]
	layout 'layouts/dashboard'

	def index
		@download_hit_counters = DownloadHitCounter.all.order(file: :asc)
	end


	def edit
	end

	def update
		if @download_hit_counter.update(download_hit_params)
		  redirect_to download_hit_counters_path, notice: 'Download stats successfully updated'
    else
      redirect_to download_hit_counters_path
      flash[:error] = @download_hit_counter.errors.full_messages.join(", ")
    end
  end

	private

	def set_download_hit_counter
		@download_hit_counter = DownloadHitCounter.find(params[:id])
	end

	def download_hit_params
		params.require(:download_hit_counter).permit(:file, :download_count, :estimated_read_time)
	end

	def check_admin
		redirect_to root_path and return if current_user.tutor?
	end

end
