# == Schema Information
#
# Table name: mcq_answers
#
#  id         :integer          not null, primary key
#  answer     :text
#  correct    :boolean
#  mcq_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :mcq_answer do
    answer "The mighty answer"
    correct false
    association :mcq, factory: :mcq
  end
end
