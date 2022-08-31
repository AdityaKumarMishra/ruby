class McqHoursController < ApplicationController
	before_action :authenticate_user!
  	before_action :set_mcq_stem, only: [:index, :create, :destroy]
  	layout 'layouts/dashboard'

  	def index
	    @mcq_hour = @mcq_stem.mcq_hours.new(user_id: current_user.id, logging_type: params[:logging_type])
	    @mcq_hours = @mcq_stem.mcq_hours.user_hours(current_user.id,params[:logging_type])
	    @selected_date,@from_filter,@to_filter = Appointment.default_pay_periods
	end

  	def create
	    @mcq_hour = McqHour.new(mcq_hour_params)
	    respond_to do |format|
	      if @mcq_hour.save
	        format.html { redirect_to mcq_hours_path(id: @mcq_stem.id, logging_type: @mcq_hour.logging_type), notice: 'Hour(s) have been successfully logged' }
	      else
	        format.html { render :log_hours }
	        flash[:error] = 'Please review the problems below.'
	      end
	    end
  	end

  	def destroy
    	mcq_hour = current_user.mcq_hours.where(logging_type: params[:logging_type]).last
	    respond_to do |format|
	      if mcq_hour.present?
	        if mcq_hour.destroy
	          format.html { redirect_to mcq_hours_path(id: @mcq_stem.id, logging_type: params[:logging_type]), notice: 'Successfully deleted last entry' }
	        else
	          format.html { redirect_to mcq_hours_path(id: @mcq_stem.id, logging_type: params[:logging_type]), alert: 'Unable to delete last entry' }
	        end
	      else
	        format.html { redirect_to mcq_hours_path(id: @mcq_stem.id, logging_type: params[:logging_type]), alert: 'No such entry exists!' }
	      end
	    end
  	end

  	private


  	def set_mcq_stem
    	@mcq_stem = McqStem.find(params[:id])
    	authorize @mcq_stem
    	@difficulty = @mcq_stem.difficulty
  	end

  	def mcq_hour_params
    	params.require(:mcq_hour).permit(:hours, :user_id, :logging_type, :mcq_stem_id)
  	end

end
