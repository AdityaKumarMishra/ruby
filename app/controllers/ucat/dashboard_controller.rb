class Ucat::DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'ucat_dashboard'

  def home
    @only_dd_pending = false
    @only_expired_course = false
    if current_user.student? && !current_user.paid_courses.present? && (current_user.orders.where(status: :ongoing).present? && current_user.orders.where(status: :ongoing).last.purchase_items.present?) && AdminControl.find_by(name: 'Signup view').try(:new_view)
      if  current_user.payment_flow_step.present? && request.path != current_user.payment_flow_step
        redirect_to current_user.payment_flow_step
      else
        current_user.orders.where(status: :ongoing).last
      end
    elsif current_user.student? && !current_user.confirmed?
      render layout: 'layouts/student_page'
    elsif current_user.student? && !current_user.questionnaire.present? && (current_user.paid_courses.present? || current_user.orders.pending.present?) && (!current_user.has_free_trial_only? || params[:update_background])
      if (current_user.active_course.present? && current_user.active_course.customable? && !current_user.address.present?)
        redirect_to current_user.payment_flow_step
      else
        @update_background = true
        @user = current_user
        @user.build_questionnaire
        render layout: 'layouts/student_page'
      end
    elsif !current_user.paid_courses.present? && current_user.orders.pending.present?
      @only_dd_pending = true
      render layout: 'layouts/student_page'
    elsif (current_user.paid_enrolments.count == 1) && ((current_user.paid_enrolments.first.trial? && current_user.paid_enrolments.first.trial_expired?) || current_user.paid_enrolments.first.course.expired?)
      @only_expired_course = true
    else
      @update_background = false
      @announcement = get_dashboard_announcement
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id) if @announcement.present?
      @last_order = current_user.orders.where(status: Order.statuses[:paid]).last
    end
  end

end
