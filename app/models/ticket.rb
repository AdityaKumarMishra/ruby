class Ticket < ApplicationRecord
  attr_accessor :signup_form_start_time, :signup_form_end_time

  belongs_to :asker, class_name: 'User', inverse_of: :tickets, optional: true
  belongs_to :answerer, class_name: 'User', optional: true
  belongs_to :resolver, class_name: 'User', optional: true
  belongs_to :questionable, polymorphic: true, optional: true
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :ticket_answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :question, :tags, :answerer, presence: true
  # validates :phone_number, numericality: true
  # validates_length_of :phone_number, minimum: 10, maximum: 15
  attr_accessor :skip_resolved_mail, :subtitle
  after_create :mail, :set_default_status, :create_enquiry_user
  after_update :follow_up_required_start_date
  after_update :resolved_mail, unless: :skip_resolved_mail
  after_commit :set_opened_at, on: [:update]

  enum status: [:resolved, :unresolved, :follow_up_required]
  scope :three_day_old_tickets, -> { where("Date(created_at) >= ?", Date.today - 3.days) }
  scope :two_day_old_tickets, -> { where("Date(created_at) >= ?", Date.today - 2.day) }
  scope :unresolved_tickets, ->  { where(status: 1) }
  CONSIDERED_OVERDUE_DAYS = 2
  CONSIDERED_OLD_DAYS = 14


  def created_hours
    (Time.zone.now - created_at)/3600
  end

  def not_count_weekends(comapre_hours)
    case created_at.wday
      when 5
        comapre_hours + 48
      when 6
        hours_get = (created_at.end_of_day - created_at) / 1.hours
        comapre_hours + 24 + hours_get
      when 0
        hours_get = (created_at.end_of_day - created_at) / 1.hours
        comapre_hours + hours_get
    end
  end

  filterrific(
    available_filters: [
        :sorted_by,
        :tag_filter,
        :answerer_filter,
        :asker_filter,
        :resolved_filter,
        :ticket_filter,
        :keyword_filter,
        :feedback_filter,
        :with_start_filter,
        :with_end_filter,
        :complaint_filter
    ]
  )

  scope :sorted_by, -> (sort_key) do
    case sort_key
    when /answerer_name/
      includes(:answerer).order('users.first_name || users.last_name')
    when /asker_name/
      includes(:asker).order('users.first_name || users.last_name')
    when /name/
      order(:title)
    when /created_at/
      order('tickets.created_at DESC')
    when /updated_at/
      order('tickets.updated_at DESC')
    end
  end

  scope :tag_filter, -> (tag_id) { joins(:tags).where(tags: { id: Tag.find(tag_id).self_and_descendants_ids }) }
  scope :answerer_filter, -> (answerer_id) { includes(:ticket_answers).where("answerer_id=?", answerer_id).references(:ticket_answers)}
  scope :asker_filter, -> (asker_id) { where(asker_id: asker_id) }
  scope :with_start_filter, -> (start_date) { where("tickets.created_at>=?", start_date) }
  scope :with_end_filter, -> (end_date) { where("tickets.created_at<=?", end_date  ) }
  #scope :keyword_filter, -> (title) { where("lower(title) LIKE ?" , "%#{title.downcase}%") }
  #scope :keyword_filter, -> (question) { where("lower(question) LIKE ?" , "%#{question.downcase}%") }
  scope :resolved_filter, -> (status){ where(status: status)}
  scope :complaint_filter, -> (complaint){
    where(complaint: complaint)}

  scope :feedback_filter, lambda { |option|
        where(feedback: option)
      }
  scope :unanswered, -> {Ticket.includes(:ticket_answers).where(:ticket_answers => {:ticket_id => nil})}
  scope :overdue, -> {unanswered.where("tickets.created_at < ?", CONSIDERED_OVERDUE_DAYS.days.ago)}
  scope :old_unanswered, -> {unanswered.where("tickets.created_at < ?", CONSIDERED_OLD_DAYS.days.ago)}

  def self.searchable_columns
    [:title, :question]
  end

  scope :keyword_filter, -> (term){ where "tickets.title ILIKE :term OR tickets.email ILIKE :term OR tickets.question ILIKE :term OR tickets.phone_number ILIKE :term OR tickets.first_name ILIKE :term OR tickets.last_name ILIKE :term OR cast(tickets.id as text) ILIKE :term", term: "%#{term}%" }

  # Sends reminder emails to the assigned answerers of unanswered questions
  def self.send_reminders
    if Rails.env.production?
      Ticket.where("status = ? AND opened_at < ?", Ticket.statuses["unresolved"], (Time.zone.now - 1.day)).each do |ticket|
        unless ticket.answerer.nil?
          TicketMailer.new_question_reminder(ticket).deliver_later  if ENV['EMAIL_CONFIRMABLE'] != "false"
        end
      end
    end
  end

  # GRAD-2374 - GetClarity - Follow up required mailer
  def self.ticket_follow_up_required
    Rails.logger.debug("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ticket_follow_up_required <<<<<<<<<<<<<<<<<<<<")
    Rails.logger.debug("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ticket_follow_up_required <<<<<<<<<<<<<<<<<<<<")
    Rails.logger.debug("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ticket_follow_up_required <<<<<<<<<<<<<<<<<<<<")
    if Rails.env.production? && ENV['EMAIL_CONFIRMABLE'] != "false"
      Ticket.where(status: 2).each do |ticket|
        if ticket.follow_up_date.present? && (ticket.follow_up_hours >= 72 && ticket.follow_up_hours < 73)
          TicketMailer.ticket_follow_up_mail(ticket).deliver_later
        end
      end
    end
  end

  def self.ticket_follow_up_required_every_24_hours_after_72_hours
    if Rails.env.production? && ENV['EMAIL_CONFIRMABLE'] != "false"
      Ticket.where(status: 2).each do |ticket|
        if ticket.follow_up_date.present? && ticket.follow_up_hours >= 96
          TicketMailer.ticket_follow_up_mail(ticket).deliver_later
        end
      end
    end
  end

  def self.mark_as_resolved_in_7_days
    Ticket.where.not(status: 0).each do |ticket|
      if ticket.mark_for_resolved? && ticket.start_date_for_resolved.present?
        if ticket.start_date_for_resolved.to_date == Date.today
          ticket.update(status: 0)
          TicketMailer.mark_as_resolved_in_7_days_mail(ticket).deliver_later
        end
      end
    end
  end

  def self.options_for_statuses
    names = []
    Ticket.statuses.map do |status, key|
      display_name = I18n.t("ticket.display_status.#{status}", default: status.titleize)
      names << [display_name, key]
    end
    names
  end

  def self.send_escalation_reminders
    if Rails.env.production?
      Ticket.two_day_old_tickets.unresolved_tickets.each do |ticket|
        TicketMailer.check_response_regarding_question(ticket).deliver_later if (ticket.created_at + 2.days).today? && ENV['EMAIL_CONFIRMABLE'] != "false"
      end
    end
  end

  def self.options_for_sorted_by
    [
      ['Question Title (a-z)', 'name'],
      ['Creation Date (newest first)', 'created_at'],
      ['Answerer Name (a-z)', 'answerer_name'],
      ['Date Last Updated (newest to oldest)', 'updated_at']
    ]
  end

  def self.send_enable_reminder
    if Rails.env.production?
      Ticket.unresolved_tickets.each do |ticket|
        if (((ticket.updated_at + 2.day) <= Time.zone.today) && ticket.remind) && ENV['EMAIL_CONFIRMABLE'] != "false"
          TicketMailer.unresolved_reminder(ticket).deliver_later
        end
      end
    end
  end

  def asker_firstname
    asker.present? ? asker.first_name : first_name
  end

  def asker_lastname
    asker.present? ? asker.last_name : last_name
  end

  def asker_email
    asker.present? ? asker.email : email
  end

  def asker_phonenumber
    asker.present? ? asker.phone_number : phone_number
  end

  def asker_full_name
    "#{asker_firstname} #{asker_lastname}"
  end

  def has_access?(user)
    # If they're not logged in, they have access if the question is public
    # and any of its tags are public
    if user.nil?
      public? && tags.any?(&:is_public?)

      # If the user asked the question they have access no matter what
    elsif user == asker
      true

      # If the user is another student, they have access if it's public and they have a relevant
      # tag, or else the tag is public
    elsif user.student?
      public? && tags.any? do |tag|
        user.tags.include?(tag) || tag.is_public?
      end

      # Otherwise, if they're staff, they have access
    else
      true
    end
  end

  def follow_up_hours
    (Time.zone.now - follow_up_date)/3600
  end

  private

  def set_default_status
    self.update_attribute(:opened_at, self.updated_at)
    self.update_attribute(:status, "unresolved") if self.status.nil?
    self.update_attribute(:asker_id, nil) if self.status == "follow_up_required"
  end

  def set_opened_at
    if previous_changes[:status].present? && self.status == "unresolved"
      self.update_attribute(:opened_at, self.updated_at)
    end
  end


  def create_enquiry_user
    EnquiryUser.create(email: self.email, first_name: self.first_name, last_name: self.last_name, phone_number: self.phone_number, question_tags: self.tags.ids) if self.asker_id.nil? && self.email.present?
  end

  def mail
    # if student allocated a tutor to answer
    if self.feedback == "No" && self.status != "follow_up_required"
      TicketMailer.confirm_ticket_sent(self).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
      autoemail = Autoemail.find_by(category: 0)
      if autoemail.present? && autoemail.is_active
        TicketMailer.send_autoresponse(self,autoemail.id).deliver_later
      end
      if answerer
        TicketMailer.new_question_with_answerer(self).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
      else
        # notify all relevant staff
        # tutors = @ticket.tags.map(&:self_and_ancestors).flatten.uniq.map(&:tutors).flatten.uniq
        staffs = tags.map(&:staffs).flatten.uniq
        staffs.each do |staff|
          TicketMailer.new_question(self, staff).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        end
      end
    end
  end

  def resolved_mail
    if self.status_changed? && self.status == "resolved" && ENV['EMAIL_CONFIRMABLE'] != "false"
      TicketMailer.ticket_resolved(self).deliver_later
      TicketMailer.assigned_ticket_resolved(self).deliver_later if self.answerer != self.resolver
    end
  end

  def follow_up_required_start_date
    if self.status_changed?
      follow_date = if self.status == 'follow_up_required'
                      Time.zone.now
                    else
                      nil
                    end
      self.update_column(:follow_up_date, follow_date)
    end
  end
end
