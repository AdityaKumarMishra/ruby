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

FactoryGirl.define do
  factory :answer_option do

    content "answer"
    application_question {FactoryGirl.create(:application_question)}
  end
end