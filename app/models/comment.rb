class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user, optional: true
  belongs_to :enquiry_user, optional: true

  after_create :mail, :update_ticket

  validates :commentable, :content, presence: true

  private

  def update_ticket
    if self.commentable_type == "TicketAnswer"
      ticket = self.commentable.ticket
      ticket.update(updated_at: Time.zone.now)
    end
  end

  def mail
    if ENV['EMAIL_CONFIRMABLE'] != "false"
      if self.commentable_type == "EssayTutorFeedback"
        EssayTutorMailer.feedback_comment_by_tutor(self).deliver_later if (self.commentable.user != self.user)
        if self.commentable.essay_response.essay_tutor_response
          EssayTutorMailer.feedback_comment_by_student(self).deliver_later if (self.commentable.user == self.user)
        end
      else
        TicketMailer.new_comment_tutor(self).deliver_later
        TicketMailer.new_comment_student(self).deliver_later
        TicketMailer.new_comment_assignee(self).deliver_later if self.user.present? && (self.user != self.commentable.ticket.answerer.email)
        autoemail = Autoemail.find_by(category: 0)
        if autoemail.present? && autoemail.is_active
          TicketMailer.send_autoresponse(self,autoemail.id).deliver_later
        end
      end
    end
  end
end
