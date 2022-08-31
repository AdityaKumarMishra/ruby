# == Schema Information
#
# Table name: tutor_answers
#
#  id             :integer          not null, primary key
#  answer         :text
#  date_published :datetime
#  published      :boolean
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TutorAnswer < ApplicationRecord
  belongs_to :user, optional: true
  has_many :student_questions

  validates_presence_of :date_published, :user_id
  validates :answer, presence: true, length: { maximum: 500 }
end
