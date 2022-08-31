class McqHourService < ApplicationService

	def initialize(params, filterrific)
		@params = params
		@filterrific = filterrific
		@filter_type = params[:filter_type].present? ? params[:filter_type] : 'pay_period'
	end

	def payment_data(current_user)
		if @filter_type == 'pay_period'
			@filterrific.with_start = nil
			@filterrific.with_end = nil
			if @params[:with_pay_period].present?
	      		from_filter, to_filter = @params[:with_pay_period].split(' - ')
	      		selected_date = @params[:with_pay_period]
	    	else
	    		selected_date,from_filter,to_filter = Appointment.default_pay_periods
	    	end
	    else
	    	if @params[:reset]
	    		@filterrific.with_start = nil
			    @filterrific.with_end = nil
			    selected_date,from_filter,to_filter = Appointment.default_pay_periods
	    	elsif @params[:filterrific].present? && (@params[:filterrific][:with_start].present? || @params[:filterrific][:with_end].present?)
	    		from_filter = @params[:filterrific][:with_start]
		        to_filter = @params[:filterrific][:with_end]
		        selected_date = "#{from_filter} - #{to_filter}"
	    	else
	    		selected_date,from_filter,to_filter = Appointment.default_pay_periods
	    	end
	    end

    	@mcq_hours = McqHour.all
    	@mcq_hours = @mcq_hours.created_with_start(from_filter) if from_filter.present?
    	@mcq_hours = @mcq_hours.created_with_end(to_filter) if to_filter.present?

		set_hours_and_stem_data(current_user)
		if @params[:selection] == 'By MCQ'
	    	return @mcq_hours, @mcq_stems, @total_hours, @totals, @total_size, @file_name, selected_date, from_filter, to_filter, @filter_type
	    else
	    	return @mcq_hours, @mcq_stems, @users, @totals, @total_size, @file_name, selected_date, from_filter, to_filter, @filter_type
	    end
	end

	def payment_data_all
    	set_hours_and_stem_data(nil)
    	return  @total_hours, @mcq_stems, @mcq_hours, @total_size, @file_name, @totals
	end

	private

		def set_hours_and_stem_data(current_user)
			if @params[:selection] == 'By Staff'
				@mcq_stems = McqStem.includes(:tags).where(id: @mcq_hours.pluck(:mcq_stem_id).uniq).order(:id)
		      	@users = User.where(id: @mcq_hours.pluck(:user_id).uniq).distinct
		      	set_hours_data
		      	@users = @users.paginate(page: @params[:page], per_page: 10) unless @params[:format] == 'xls'
		      	@users = @users.paginate(page: @params[:current_page], per_page: 250) if @params[:current_page].present? && @params[:format] == 'xls'
		      	@total_size = @users.count
		      	@file_name = "MCQ Logged Hours By Staff, Payment Data - (#{@from_filter} - #{@to_filter}) - Downloaded on #{Date.today}#{ @params[:current_page].present? ? ' - Page ' + @params[:current_page] : '' }"
		    else
		    	if @params[:selection] == 'By MCQ'
					@mcq_hours = @mcq_hours.where(user_id: current_user.id) if current_user.tutor? 
					@mcq_stems = McqStem.where(id: @mcq_hours.pluck(:mcq_stem_id).uniq).order(:id)
			      	@file_name = "MCQ Logged Hours, Payment Data - (#{@from_filter} - #{@to_filter}) - Downloaded on #{Date.today}#{ @params[:current_page].present? ? ' - Page ' + @params[:current_page] : '' }"
			    else
			    	@mcq_stems = @filterrific.find.reorder('id ASC')
			    	@mcqs = Mcq.where(mcq_stem_id: @mcq_stems.ids)
			    	@filterrific_params = @params[:filterrific]
      				@mcqs, @mcq_stems = exam_mcqs(@mcqs, @mcq_stems) if @filterrific_params.present? && @filterrific_params[:with_pool] == '1'
	    			@mcq_hours = McqHour.where(mcq_stem_id: @mcq_stems.map(&:id).uniq)
		    		@file_name = "MCQ Logged Hours, Payment Data - (All) - Downloaded on #{Date.today}#{ @params[:current_page].present? ? ' - Page ' + @params[:current_page] : '' }"
			    end
    			set_hours_data
    			@total_hours = @mcq_hours.map(&:hours).sum.round(2)
    			@mcq_stems = @mcq_stems.paginate(page: @params[:page], per_page: 10) unless @params[:format] == 'xls' || @params[:current_page].present?
			    if @mcq_stems.count >= 30
	   				@mcq_stems = @mcq_stems.paginate(page: @params[:current_page], per_page: 250) if @params[:current_page].present? && @params[:format] == 'xls'
	   			else
	   				@mcq_stems = @mcq_stems if @params[:format] == 'xls'
	   			end
	   			@mcq_hours = McqHour.where(mcq_stem_id: @mcq_stems) if @params[:selection] == 'By MCQ'
	    		@total_size = @mcq_stems.count
			end

		end

		def set_hours_data
		    @totals = {}
			hours =  @mcq_hours.joins(mcq_stem: :mcqs).select("json_build_object(CASE WHEN mcq_hours.logging_type = 0 THEN 'author' WHEN mcq_hours.logging_type = 1 THEN 'reviewer_1' WHEN mcq_hours.logging_type = 2 THEN 'reviewer_2' WHEN mcq_hours.logging_type = 3 THEN 'video_explainer' WHEN mcq_hours.logging_type = 4 THEN 'video_explanation_reviewer' END ,  array_agg(DISTINCT mcq_hours.id), 'mcq_count', COUNT(mcqs.*))").group('mcq_hours.logging_type').as_json
		    if hours.present?
			    arr = hours.each_with_object({}) { |h, o| h.each { |k,v| (o[k] ||= []) << v } }["json_build_object"]
			    arr.each do |data| 
			    	total_hours = McqHour.where(id: data.values[0]).pluck(:hours).compact.sum.to_f.round(2)
			    	@totals["#{data.keys.first}_hours".to_sym] = total_hours
			    	@totals["#{data.keys.first}_hours_per_mcq".to_sym] = (total_hours / data.values[1]).round(2) rescue 0.0
			    end
			end
		end
end