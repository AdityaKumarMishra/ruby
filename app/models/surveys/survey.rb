# == Schema Information
#
# Table name: surveys
#
#  id             :integer          not null, primary key
#  title          :string
#  date_published :datetime
#  date_start     :datetime
#  published      :boolean
#  date_closed    :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#

class Surveys::Survey < ApplicationRecord
  extend FriendlyId

  before_save :check_published

  has_many :user_surveys, :class_name => 'Surveys::UserSurvey', :dependent => :destroy
  has_many :users, :through => :user_surveys
  has_many :survey_questions, :class_name => 'Surveys::SurveyQuestion', dependent: :destroy

  friendly_id :title, use: :slugged

  validates :title, presence: true
  validates :date_start, presence: true
  validates :date_closed, presence: true

  scope :for_user, -> (user) { joins(:users).where('users.id' => user.id)}
  scope :active, -> {where('published IS TRUE AND NOW() BETWEEN date_start and date_closed') }

  def to_s
    title
  end

  def user_survey user
    user_surveys.for_user(user).first
  end

  def is_submited user
    completed = user_survey(user).is_submited
  end
  alias_method :is_submited?, :is_submited

  def mark_submited user
      completed = true
      survey_questions.each { |question|
        completed = false if !question.is_answered user
      }
  end

  private
  def check_published
    self.date_published = DateTime.current if published
  end
end
