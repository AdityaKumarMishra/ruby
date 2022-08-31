# == Schema Information
#
# Table name: mcq_stems
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :mcq_stem do
    title { FFaker::Lorem.word + FFaker::Lorem.characters(5)}
    description 'MyText'
    difficulty 35
    examinable false
    skill_tag SkillTag.create(tag_name: 'test tag')
    similarity_score Random.rand(0..5)
    association :author, factory: [:user, :tutor]
    published true
    reviewed true
    trait :examinable do
      examinable true
      before(:create) do |m|
        m.mcqs << FactoryGirl.build(:mcq, mcq_stem: m)
      end
    end

    after(:build) do |m|
      tag = FactoryGirl.create :tag
      reviewer = FactoryGirl.create :user, :tutor
      author = FactoryGirl.create :user, :tutor
      m.tags << tag
      m.reviewer = reviewer
      m.author = author
    end
  end
end
