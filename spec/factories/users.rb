# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  username               :string
#  date_of_birth          :date
#  date_signed_up         :datetime
#  role                   :string
#  bio                    :text
#  profile_image          :string
#  slug                   :string
#

FactoryGirl.define do
  sequence(:date_of_birth) { |n| "#{Date.yesterday - n}" }

  factory :user do
    slug { FFaker::Internet.slug + FFaker::Lorem.characters(5) }
    email { FFaker::Internet.email }
    password 'password'
    password_confirmation 'password'
    confirmed_at { Time.zone.now }
    first_name 'Test'
    last_name 'User'
    username { FFaker::InternetSE.user_name_variant_long }
    date_of_birth
    date_signed_up { Time.zone.now }
    bio 'This is the story about the greatest life ever.'
    profile_image 'profile_image.img'
    phone_number 9818181823

    trait :student do
      role :student
    end

    trait :tutor do
      after :create do |user|
        FactoryGirl.create(:tutor_profile, tutor_id: user.id)
      end
      role :tutor
    end

    trait :manager do
      role :manager
    end

    trait :admin do
      role :admin
    end

    trait :superadmin do
      role :superadmin
    end

    trait :questionnaire do
      questionnaire { FactoryGirl.create(:questionnaire) }
    end

    trait :lost_tickets do
      username "lost.tickets"
    end
  end
end
