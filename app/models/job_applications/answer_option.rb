# == Schema Information
#
# Table name: answer_options
#
#  id                  :integer          not null, primary key
#  content             :text
#  application_question_id   :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#


class AnswerOption < ApplicationRecord
  belongs_to :job_application, optional: true
  belongs_to :application_question

  validates :content, presence: { message: "Please provide an answer" }

end
