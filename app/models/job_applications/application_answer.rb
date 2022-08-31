# == Schema Information
#
# Table name: application_answers
#
#  id                  :integer          not null, primary key
#  content             :text
#  dropdown_question_id    :integer
#  application_question_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#


class ApplicationAnswer < ApplicationRecord
  belongs_to :job_application
  belongs_to :application_question

  def parse_answer
    if application_question.answer_type.eql?('dropdown_multiple')
      answers = content.scan(/\".\"/).each do |a|
          a[0] = a[-1] = ''
      end
    else
      [content]
    end
  end
end
