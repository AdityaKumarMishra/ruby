# == Schema Information
#
# Table name: tutor_profiles
#
#  id             :integer          not null, primary key
#  tutor_id	      :integer
#  private_tutor  :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :tutor_profile do
    private_tutor true

    after(:create) do |tutor_profile|
      FactoryGirl.create(:tutor_schedule, tutor_profile_id: tutor_profile.id)
    end

    factory :tutor_profile_with_tutor_availabilities do
      transient do
        tutor_availability_count 1
      end

      after(:create) do |tutor_profile, evaluator|
        create_list(:tutor_availability, evaluator.tutor_availability_count, tutor_profile: tutor_profile)
      end
    end

    factory :tutor_profile_with_tags do
      transient do
        tags_count 2
      end

      after(:create) do |tutor_profile, evaluator|
        create_list(:tag, evaluator.tags_count, tutor_profiles: [tutor_profile])
      end
    end
  end
end