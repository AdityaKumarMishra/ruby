# == Schema Information
#
# Table name: marks
#
#  id                    :integer          not null, primary key
#  value                 :float
#  correct               :boolean
#  user_id               :integer
#  essay_response_id     :integer
#  mcq_student_answer_id :integer
#  description           :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class MarkEssayResponse < Mark
  validates_presence_of :essay_response_id
end
