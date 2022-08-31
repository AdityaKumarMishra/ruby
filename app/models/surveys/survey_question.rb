# == Schema Information
#
# Table name: survey_questions
#
#  id         :integer          not null, primary key
#  survey_id  :integer
#  question   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Surveys::SurveyQuestion < ApplicationRecord
  include EditorParsable
  
  belongs_to :survey
  has_many :survey_answers, :class_name => 'Surveys::SurveyAnswer', dependent: :destroy

  validates :survey_id, presence: true
  validates :question, presence: true

  def to_s
    question
  end

  def answer_input_html_name
    "answer_for_#{id}"
  end

  def answer_for_user user
    survey_answers.where('user_id = ?', user.id).first
  end

  def is_answered user
    survey_answers.where('user_id = ? AND rating IS NOT NULL', user.id).count > 0
  end
  alias_method :is_answered?, :is_answered
end
