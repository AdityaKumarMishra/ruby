# == Schema Information
#
# Table name: essays
#
#  id              :integer          not null, primary key
#  title           :string
#  question        :text
#  date_added      :datetime
#  expiration_date :datetime
#  tutor_id        :integer
#  student_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  exam_id         :integer
#  slug            :string
#

class Essay < ApplicationRecord
  include EditorParsable
  extend FriendlyId
  include Positionable
  MAX_COUNT = 12

  belongs_to :exam, optional: true
  # belongs_to :tutor, -> { where.(role: 1) }, :class_name => 'User' #TODO replace role with tutor
  belongs_to :student, -> { where(role: 0) }, :class_name => 'User', optional: true
  has_many :essay_responses, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  accepts_nested_attributes_for :tags, allow_destroy: true
  has_many :online_mock_exam_sections, dependent: :destroy
  # belongs_to :online_mock_exam, class_name: 'OnlineMockExam', foreign_key: :online_mock_exam_id
  acts_as_commontable

  validates :title, :question, :tutor_id, :position, presence: true

  friendly_id :slug_candidates, use: :slugged

  # scope :for_student, -> (user) { where('student_id' => user.id)}
  scope :for_tutor, -> (user) { where('tutor_id' => user.id)}
  scope :additional_items, -> (user, quantity) { where('student_id <> ?', user.id).limit(quantity) }

  def tutor
    User.find(tutor_id)
  end

  def tutor_essays(current_responses, current_user)
    current_responses.where(tutor_id: current_user.id)
  end

  def unanswered_responses(current_user=nil)
    responses = essay_responses.where.not(activation_date: nil, expiry_date: nil).where("essay_responses.time_submited is ? AND essay_responses.activation_date <= ? AND essay_responses.expiry_date >= ?", nil, Date.today, Date.today)
    responses = tutor_essays(responses, current_user) if current_user.present? && current_user.tutor?
    return responses
  end

  def unmarked_responses(current_user=nil)
    responses = essay_responses.includes(:essay_tutor_response).where(essay_tutor_responses: {id: nil})
    responses = responses.where.not(time_submited: nil)
    responses = tutor_essays(responses, current_user) if current_user.present? && current_user.tutor?
    return responses
  end

  def marked_responses(current_user=nil, essay_responses)
    responses = essay_responses.includes(:essay_tutor_response).where.not( essay_tutor_responses: {id: nil})
    responses = responses.where.not(time_submited: nil)
    if current_user.present? && current_user.tutor?
      responses=tutor_essays(responses, current_user)
    end
    return responses
  end

  def other_responses(current_user=nil, essay_responses)
    responses = essay_responses.where('time_submited is ?', nil).select{ |s|  !s.is_active }.to_a

    if current_user.present? && current_user.tutor?
      responses=tutor_essays(responses, current_user)

    end
    return responses
  end

  def slug_candidates
    [
      [:title, rand(1000..100000)]
    ]
  end
end
