# == Schema Information
#
# Table name: mcq_hours
#
#  id           :integer          not null, primary key
#  hours        :integer          not null, default: 0
#  user_id      :bigint           not null, foreign key
#  mcq_stem_id  :bigint           not null, foreign key
#  logging_type :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null

FactoryGirl.define do
  factory :mcq_hour do
    hours Random.rand(1..5)
    association :user, factory: :user
    association :mcq_stem, factory: :mcq_stem
    logging_type [:author, :reviewer_1, :reviewer_2, :video_explainer, :video_explanation_reviewer].sample
  end
end
