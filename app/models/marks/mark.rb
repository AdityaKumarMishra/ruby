require "sti_preload"
class Mark < ApplicationRecord
  belongs_to :user
  belongs_to :essay_response
  validates_presence_of :value, :user_id
  validates :description, inclusion: { in: ['Easy', 'Medium', 'Hard'] }

  scope :current_tutor, -> (tutor){ where(user_id: tutor) }
end
