class TicketAnswer < ApplicationRecord
  belongs_to :ticket
  belongs_to :user, optional: true
  has_many :votes, as: :votable
  has_many :comments, as: :commentable, dependent: :destroy
  validates :ticket, :user, :content, presence: true


  scope :with_start, -> (with_start) do
    where('date(ticket_answers.created_at) >= ?', with_start)
  end
  scope :with_end, -> (with_end) do
    where('date(ticket_answers.created_at) <= ?', with_end)
  end

  def changed_to_public?
  	previous_changes.key?('public') && previous_changes[:public][1] == true
  end

  def helpfulness
  	votes.count
  end

  def created_hours
    (Time.zone.now - created_at)/3600
  end

  after_create :mail, :update_ticket

  private

  def update_ticket
    ticket = self.ticket
    ticket.update(updated_at: Time.zone.now)
  end

  def mail
    if ENV['EMAIL_CONFIRMABLE'] != "false"
      TicketMailer.new_answer(self).deliver_later
      TicketMailer.answer_to_assigned_ticket(self).deliver_later if self.user != self.ticket.answerer
    end
  end
end
