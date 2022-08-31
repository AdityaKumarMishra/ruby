class TicketsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :make_public, :make_private, :toggle_reminder]
  # invisible captcha issue in rails 6 
  #invisible_captcha only: [:create], honeypot: :subtitle
  # before_action :check_if_manager, only: [:make_public, :make_private]

  # GET /tickets
  # GET /tickets.json
  def index
    authorize Ticket
    @tickets = policy_scope(Ticket)
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new(asker: current_user)
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create

    #
    # if params[:ticket].include? :asker_attributes
    #   asker = User.create_temporary(**params[:ticket][:asker_attributes].to_h)
    #   public = true
    # else
    #   asker = current_user
    #   public = false
    # end
    tag_ids = ticket_params[:tag_ids] || []
    unless params[:is_admin_ticket]
      seconds_difference = (BigDecimal(params[:ticket][:signup_form_end_time].presence || 0) / 1000) - (BigDecimal(params[:ticket][:signup_form_start_time].presence || 0)/ 1000)
      honeypot_filled = params[:ticket][:last_name].present?
      # Add any tags based on the content linked to it

      if (seconds_difference < 2 || honeypot_filled)
        redirect_to root_path, alert: 'Unable to create ticket, please try again later'
        return
      end
    end
    if ticket_params.include?(:questionable_id) && ticket_params.include?(:questionable_type)
      content = ticket_params[:questionable_type].constantize.find(ticket_params[:questionable_id])
      tag_ids.concat(content.tags.map(&:id))
    end
    # Select only the most specific tag IDs, ie remove redundant parent tags
    tag_ids = Tag.most_specific_ids(tag_ids)
    if params[:commit] == 'public_query'
      # pub_answrer = StaffProfile.includes(:tags).where(tags: {id: tag_ids}).first.try(:staff)
      tutors = StaffProfile.includes(:tags).where(tags: {id: tag_ids}).map{ |tutor| tutor.staff.tutor_profile }
      tutors.each{|t| if t.issue_ticket == true;@tutor_id = t; end}
      pub_answrer = @tutor_id.try(:tutor)
      ticket_params.merge(answerer_id: pub_answrer.try(:id))
      # Create the new Ticket
      @ticket = Ticket.new(ticket_params.merge(tag_ids: tag_ids, answerer_id: pub_answrer.try(:id))) # current_user.tickets.new(ticket_params)
    else
      # Create the new Ticket
      @ticket = Ticket.new(ticket_params.merge(tag_ids: tag_ids)) # current_user.tickets.new(ticket_params)
    end
    if params[:type] == "follow_up_required" && params[:is_admin_ticket].blank?
      @ticket.status = 2
      @ticket.asker_id = current_user.id
    end
    respond_to do |format|
      if (@ticket.asker.present? || (!@ticket.asker.present? && verify_recaptcha(model: @ticket))) && @ticket.save
        path =  if params[:ticket][:given_type].present?
              fetch_redirect_path
            elsif @ticket.questionable_type == 'Vod'
              vod_path(@ticket.questionable_id)
            elsif @ticket.questionable_type == 'Textbook'
              textbook_path(@ticket.questionable_id)
            elsif @ticket.questionable_type == 'Document'
              documents_path
            elsif params[:given_type] == 'policy_fail'
              params[:current_path]
            elsif params[:type] == 'unresolved_issues'
              params[:current_path]
            elsif params[:commit] == 'public_query'
              params[:query_path]
            elsif params[:type] == 'follow_up_required'
              request.referer
            else
              contact_path
            end

        # Redirect to ticket URL
        msg = params[:type] == 'follow_up_required' ? "Ticket was successfully created" : "Thank you. Please check your email for a confirmation email of inquiry receipt. If you do not receive such an email, please resubmit a ticket and check that you have put in your email address correctly."
        format.html { redirect_to path, notice: msg }
        # format.html { redirect_back fallback_location: root_path, notice: "Thank you, we'll get back to you shortly." }
        format.json { render :show, status: :created, location: @ticket }
        if @ticket.feedback == "Yes" && ENV['EMAIL_CONFIRMABLE'] != "false"
          TicketMailer.ticket_feedback(@ticket, current_course).deliver_later
        end
      else
        @content = content
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        if params[:transfer_ticket].present? && params[:transfer_ticket]=="true"
          answerer = User.find(ticket_params[:answerer_id]) if params[:ticket][:answerer_id]
          TicketMailer.transfer_ticket(@ticket, answerer, current_user).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
          msg="Ticket was successfully transferred"
        else
          msg="Ticket was successfully updated"
        end

        format.html { redirect_to url_for(action: :show, controller: :issue_forum, params: { id: @ticket.id }), notice: msg }

        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def escalate_issue
    ticket = Ticket.find(params[:id])
    if ticket.escalated?
      redirect_to gamsat_preparation_courses_contact_url, notice: "You have already escalated the issue. We’ll get back to you shortly."
    else
      ticket.update(escalated: true)
      if ENV['EMAIL_CONFIRMABLE'] != "false"
        TicketMailer.escalate_mail_to_staff(ticket).deliver_later
        TicketMailer.escalate_mail_to_student(ticket).deliver_later
      end
      redirect_to gamsat_preparation_courses_contact_url, notice: "Your issue has been escalated. We’ll be in touch shortly."
    end

  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_back_with_fallback tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tags
    @tags = current_user.accessible_tags
    respond_to do |format|
      format.json
    end
  end

  def make_public
    @ticket.update(public: true)
    respond_to do |format|
      format.html { redirect_to url_for(action: :show, controller: :issue_forum, params: { id: @ticket.id }), notice: 'Ticket was made public' }
    end
  end

  def make_private
    @ticket.update(public: false)
    respond_to do |format|
      format.html { redirect_to url_for(action: :show, controller: :issue_forum, params: { id: @ticket.id }), notice: 'Ticket was made private' }
    end
  end

  def mark_complaint
    @ticket = Ticket.find(params[:id])
    @ticket.update(complaint: params[:complaint] == "true" ? true : false)
    respond_to do |format|
      format.html { redirect_to url_for(action: :show, controller: :issue_forum, params: { id: @ticket.id }), notice: 'Ticket was made mark as complaint' }
    end
  end

  def mark_for_resolved
    @ticket = Ticket.find(params[:id])
    mark_value = params[:mark_for_resolved] == "true" ? true : false
    date = params[:mark_for_resolved] == "true" ? Time.zone.now + 7.days : nil
    @ticket.update(mark_for_resolved: mark_value, start_date_for_resolved: date)
    respond_to do |format|
      format.html { redirect_to url_for(action: :show, controller: :issue_forum, params: { id: @ticket.id }), notice: 'Ticket was made mark as resolved in 7 days' }
    end
  end

  def toggle_reminder
    @ticket = Ticket.find(params[:id])
    @ticket.toggle(:remind)
    @ticket.save!
    respond_to do |format|
      format.html { redirect_to url_for(action: :show, controller: :issue_forum, params: { id: @ticket.id }), notice: 'Reminder changed successfully' }
    end
  end

  def destroy_old_issues
    Ticket.old_unanswered.destroy_all
    respond_to do |format|
      format.html { redirect_to dashboard_unresolved_issues_path, notice: 'Overdue Issues were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def fetch_redirect_path
    case @ticket.given_type
    when 'Exercise'
      path = review_exercise_exercise_review_path(exercise_id: @ticket.given_id, ticket_id: @ticket.id)
    when 'SectionAttempt'
      section_attempt = SectionAttempt.find(@ticket.given_id)
      if section_attempt.assessment_attempt.assessable_type == 'DiagnosticTest'
        path = review_diagnostic_test_attempt_section_attempt_section_item_attempts_path(section_attempt.assessment_attempt, section_attempt, ticket_id: @ticket.id)
      else
        path = review_online_exam_attempt_section_attempt_section_item_attempts_path(section_attempt.assessment_attempt, section_attempt, ticket_id: @ticket.id)
      end
    end
    path
  end

  def check_if_manager
    if current_user[:role] >= User.roles[:manager]
      true
    else
      raise 'No permission'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
    authorize @ticket
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_params
    params.require(:ticket).permit(
      :title, :email, :question, :comment, :answerer_id, :public, :status,
      :answered_at, :questionable_id, :questionable_type, :asker_id,
      :first_name, :last_name, :phone_number, :resolver_id, :feedback, :given_type, :given_id, :subtitle, :ticket_type,
      :signup_form_start_time, :signup_form_end_time,
      tag_ids: []
    )
  end
end
