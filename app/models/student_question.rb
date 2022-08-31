# == Schema Information
#
# Table name: student_questions
#
#  id              :integer          not null, primary key
#  question        :text
#  date_published  :datetime
#  published       :boolean
#  user_id         :integer
#  tutor_answer_id :integer
#  subject_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string
#

class StudentQuestion < ApplicationRecord
  extend FriendlyId

  belongs_to :user
  belongs_to :tutor_answer, optional: true
  belongs_to :subject, optional: true

  friendly_id :slug_candidates, use: :slugged

  validates_presence_of :question, :date_published,
    :user_id, :subject_id

  def slug_candidates
    if user.username.present?
      ['question',[subject.title.truncate(15), user.username.
        truncate(15), :id]]
    else
      ['question', [subject.title.truncate(15), :id]]
    end
  end
end
