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



FactoryGirl.define do
  factory :application_answer do

    content "answer"
    application_question {FactoryGirl.create(:application_question)}
  end
end