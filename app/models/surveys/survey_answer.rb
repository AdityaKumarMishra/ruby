# == Schema Information
#
# Table name: survey_answers
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  survey_question_id :integer
#  answer             :text
#  rating             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Surveys::SurveyAnswer < ApplicationRecord
  before_create :clear_old_answer
  belongs_to :user
  belongs_to :survey_question

  validates :user_id, presence: true
  validates :survey_question_id, presence: true
  validates :answer, presence: true

  def to_s
    answer
  end

  private

  def clear_old_answer
    Surveys::SurveyAnswer.where(:survey_question => survey_question, :user => user, :rating => nil).destroy_all
  end
end
