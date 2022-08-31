class InteractionLog < ApplicationRecord
  belongs_to :asker, class_name: 'User', inverse_of: :interaction_logs
  belongs_to :answerer, class_name: 'User', optional: true
  validates :interaction_type, :title, presence: true
  # validates_presence_of :opened_at, :message => "Please select the past date"
  # validates :opened_at_date_cannot_be_in_the_future

  # def opened_at_date_cannot_be_in_the_future
  #   if opened_at.present? && opened_at > Date.today
  #     errors.add(:opened_at, "can't be in the future date")
  #   end
  # end
end
