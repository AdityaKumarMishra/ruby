# == Schema Information
#
# Table name: application_questions
#
#  id                  :integer          not null, primary key
#  answer_type         :integer
#  content             :text
#  job_application_form_id     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#


FactoryGirl.define do

  FactoryGirl.define do
    factory :application_question do

      answer_type 0
      content "question"
    end
  end
end
