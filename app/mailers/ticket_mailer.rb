class TicketMailer < ApplicationMailer
  def new_question(question, tutor)
    @question = question
    @answerer = tutor

    if @question.tags.empty?
      mail(
        to: check_environment ? DEFAULT_TO : [@answerer.email, 'student.services@gradready.com.au'],
        subject: "Student #{@question.asker_firstname} raised a question",
        template_name: 'new_question'
      )
    else
      mail(
        to: check_environment ? DEFAULT_TO : [@answerer.email, 'student.services@gradready.com.au'],
        subject: "Student #{@question.asker_firstname} raised a question",
        template_name: 'new_question'
      )
    end
  end


  def transfer_ticket(question, tutor, current_user)
    @question = question
    @current_user = current_user
    @answerer = tutor
    if @question.tags.empty?
      mail(
        to: check_environment ? DEFAULT_TO : [@answerer.email, current_user.email],
        subject: "#{current_user.full_name} transfer a ticket",
        template_name: 'transfer_ticket'
      )
    else
      mail(
        to: check_environment ? DEFAULT_TO : [@answerer.email, current_user.email],
        subject: "#{current_user.full_name} transfer a ticket",
        template_name: 'transfer_ticket'
      )
    end
  end

  def confirm_ticket_sent(question)
    @question = question
    if question.asker.nil?
      email = question.email
      @first_name = question.first_name
    else
      email = question.asker.email
      @first_name = question.asker.first_name
    end
    @title = @question.title.present? ? @question.title : "Support Ticket - #{@question.id}"
    mail(
      to: check_environment ? DEFAULT_TO : email,
      subject: "Your GradReady ticket has been submitted - #{@title}"
    )
  end


  def send_autoresponse(question, autoemail_id)
    @autoemail = Autoemail.find_by(id: autoemail_id)
    unless question.class.to_s == "Comment"
      if question.asker.nil?
        email = question.email
        @first_name = question.first_name
      else
        email = question.asker.email
        @first_name = question.asker.first_name
      end
    else
      user = question.user
      email = user.try(:email)
      @first_name = user.present? ? user.first_name : ''
    end
    mail(
      to: check_environment ? DEFAULT_TO : email,
      subject: @autoemail.subject
    )
  end

  def new_question_reminder(question)
    @question = question
    @answerer = question.answerer
    @time_diff = (Date.today - @question.opened_at.to_date).to_i * 24
    mail(
        to: check_environment ? DEFAULT_TO : [@answerer.email, 'quality.assurance@gradready.com.au'],
        subject: "Reminder - #{@time_diff} hours: Student #{@question.asker_firstname} responded to your reply in #{@question.title}",
        template_name: 'question_reminder'
    )
  end

  def check_response_regarding_question(question)
    @question = question
    @title = @question.title.present? ? @question.title : "Support Ticket - #{@question.id}"
    mail(
        to: check_environment ? DEFAULT_TO : @question.asker_email,
        subject: "Have you received a response regarding #{@title}",
        template_name: 'check_response_regarding_question'
    )
  end

  def escalate_mail_to_staff(question)
    @question = question
    mail(
        to: check_environment ? DEFAULT_TO : [@question.answerer.email, 'escalations@gradready.com.au'],
        subject: "Student #{@question.asker_firstname} escalated a question",
        template_name: 'escalate_mail_to_staff'
    )
  end

  def escalate_mail_to_student(question)
    @question = question
    @title = @question.title.present? ? @question.title : "Support Ticket - #{@question.id}"
    mail(
        to: check_environment ? DEFAULT_TO : @question.asker_email,
        subject: "Escalation request has been sent",
        template_name: 'escalate_mail_to_student'
    )
  end

  def answer_satisfaction(question)
    # @question = question
    # mail(
    #     to: check_environment ? DEFAULT_TO : @question.asker_email,
    #     subject: "Follow Up Email - Satisfy by Answerer",
    #     template_name: 'satisfy_by_answer'
    # )
  end

  def new_question_reminder_no_tags(question)
    # @question = question
    # @answerer = question.answerer
    # mail(
    #     to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : [@answerer.email,'auto.emails@gradready.com.au','overdue.issues@gradready.com.au'],
    #     subject: "Student #{@question.asker_firstname} raised a question",
    #     template_name: 'new_question'
    # )
  end

  def new_question_with_answerer(question)
    new_question(question, question.answerer)
  end

  def new_answer(answer)
    @answer = answer
    @ticket = @answer.ticket
    @title = @ticket.title.present? ? @ticket.title : "Support Ticket - #{@ticket.id}"
    mail(to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : @answer.ticket.asker_email, subject: "A tutor has replied to your question '#{@title}'")
  end

  def answer_to_assigned_ticket(answer)
    @answer = answer
    mail(to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : @answer.ticket.answerer.email, subject: "A Tutor has replied to question assigned to you")
  end

  def ticket_resolved(question)
    @question = question
    mail(to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : [@question.asker_email, 'issue.ticketing@gradready.com.au'], subject: "Ticket Resolved")
  end

  def assigned_ticket_resolved(question)
    # @question = question
    # mail(to: check_environment ? DEFAULT_TO : @question.answerer.email, subject: "Ticket is resolved")
  end

  def new_comment_tutor(comment)
    @comment = comment

    if @comment.commentable_type == "Ticket"
      @ticket = @comment.commentable
    else
      @ticket = @comment.commentable.ticket
    end
    @tutor = @ticket.answerer
    @asker = @ticket.asker || @comment.enquiry_user 
    mail_sub = "Student #{@asker} has just commented on the answer of a question assigned to you"
    mail(to: check_environment ? DEFAULT_TO : @tutor.email, subject: mail_sub)
  end

  def new_comment_student(comment)
    @comment = comment
    if @comment.commentable_type == "Ticket"
      @question = @comment.commentable
    else
      @question = @comment.commentable.ticket
    end
    @tutor = @question.answerer
    @user = @question.asker ||  @comment.enquiry_user
    email = (@user.present? && @user.email.present?) ? @user.email : @question.email
    @first_name = (@user.present? && @user.first_name.present?) ? @user.first_name : @question.first_name
    if email.present? && (@tutor.email != email)
      mail_sub = "A staff has responded to your comment within a question you have posted"
      @title = @question.title.present? ? @question.title : "Support Ticket - #{@question.id}"
      mail(to: check_environment ? DEFAULT_TO : email, subject: mail_sub)
    end
  end

  def new_comment_assignee(comment)
    @comment = comment
    if @comment.commentable_type == "Ticket"
      @ticket = @comment.commentable
    else
      @ticket = @comment.commentable.ticket
    end
    @tutor = @ticket.answerer
    @asker = @ticket.asker || @comment.enquiry_user 
    mail_sub = "Student #{@asker} has just commented on the answer of a question assigned to you"
    mail_to_email_id = @tutor.email
    mail(to: check_environment ? DEFAULT_TO : mail_to_email_id, subject: mail_sub)
  end

  def unresolved_reminder(ticket)
    @ticket = ticket
    @title = @ticket.title.present? ? @ticket.title : "Support Ticket - #{@ticket.id}"
    mail(to: check_environment ? DEFAULT_TO : @ticket.answerer.email, subject: "#{@title} by #{@ticket.asker.full_name} is awaiting your answer")
  end

  def ticket_feedback(ticket, course)
    # @ticket = ticket
    # if @ticket.questionable_type == "Mcq"
    #   @title = @ticket.questionable.mcq_stem.title
    # else
    #    @title = @ticket.questionable.title
    # end
    # @student = @ticket.asker
    # @course_enrolled = course
    # mail(to: check_environment ? DEFAULT_TO : [@ticket.answerer.email, 'quality.assurance@gradready.com.au'], subject: "#{@title} has received a feedback from #{@student.full_name}")
  end

  # GRAD-2374 - GetClarity - Follow up required mailer
  def ticket_follow_up_mail ticket
    @ticket = ticket
    @tutor_mail = @ticket.answerer.email
    mail(
        to: check_environment ? DEFAULT_TO : ['quality.assurance@gradready.com.au', @tutor_mail],
        subject: 'Follow up required - no update for 72 hours'
      )
  end

  # GRAD-3124 - GetClarity - Mark as resolved in 7 days mailer
  def mark_as_resolved_in_7_days_mail ticket
    @ticket = ticket
    @student_mail = @ticket.asker.email
    mail(
        to: check_environment ? DEFAULT_TO : @student_mail,
        subject: 'Mark as resolved - no update in 7 days'
      )
  end

end
