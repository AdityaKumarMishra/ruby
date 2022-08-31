class McqPaymentDataController < ApplicationController
  before_action :authenticate_user!
  before_action :set_filterrific, only: [:payment_data, :payment_data_all]
  before_action :initialize_service
  layout 'layouts/dashboard'

  def initialize_service
  	@mcq_hour_service = McqHourService.new(params,@filterrific)
  end

  def payment_data
    params[:selection] = 'By Staff' unless params[:selection].present?
    if params[:selection] == 'By MCQ'
      @mcq_hours, @mcq_stems, @total_hours, @totals, @total_size, @file_name, @selected_date, @from_filter,@to_filter, @filter_type = @mcq_hour_service.payment_data(current_user)
    else
      @mcq_hours, @mcq_stems, @users, @totals, @total_size, @file_name, @selected_date, @from_filter,@to_filter, @filter_type = @mcq_hour_service.payment_data(current_user)
    end
    respond_to do |format|
      format.html
      format.js
      format.xls {
        response.headers['Content-Disposition'] = 'attachment; filename="' + @file_name + '.xls"'
      }
    end
  end

  def payment_data_all
  	@total_hours, @mcq_stems, @mcq_hours, @total_size, @file_name, @totals = @mcq_hour_service.payment_data_all
    respond_to do |format|
      format.html
      format.js
      format.xls {
        response.headers['Content-Disposition'] = 'attachment; filename="' + @file_name + '.xls"'
      }
    end
    rescue ActiveRecord::RecordNotFound => e
      # There is an issue with the persisted param_set. Reset it.
      redirect_to(reset_filterrific_url(format: :html)) && return
  end

  private

    def set_filterrific
      if params[:action] == 'payment_data'
        @filterrific = initialize_filterrific(
          McqHour,
          params[:filterrific]
        )
      else
        (@filterrific = initialize_filterrific(
          policy_scope(McqStem),
          params[:filterrific],
          select_options: {
            tag: Tag.options_for_select, #policy_scope(Tag).options_for_selec
            skill_tag: SkillTag.options_for_select,
            similarity_score: McqStem.options_for_select_score,
            author: User.options_for_tutor_admin_filter,
            reviewer: User.options_for_tutor_admin_filter,
            reviewer2: User.options_for_tutor_admin_filter,
            video_explainer: User.options_for_tutor_admin_filter,
            video_reviewer: User.options_for_tutor_admin_filter,
            difficulty: [:easy, :medium, :hard, :mixed],
            with_pool: McqStem.options_for_new_pool,
            with_exam: McqStem.options_for_appear_in_exam,
            sorted_by: McqStem.options_for_sorted_by,
            with_work: McqStem.options_for_work_status,
            with_status: McqStem.options_for_publish,
            with_min: McqStem.options_for_min,
            with_max: McqStem.options_for_max,
            with_graphic: McqStem.options_for_graphic
          },
          persistence_id: "shared_key",
        )) || return
      end
    end
end
