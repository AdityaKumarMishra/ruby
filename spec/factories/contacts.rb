# == Schema Information
#
# Table name: contacts
#
#  id                  :integer          not null, primary key
#  name                :string
#  position            :string
#  email               :string
#  visible             :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  contact_location_id :integer
#

FactoryGirl.define do

  sequence(:contact_name) { |n| "Johny #{n}" }
  sequence(:contact_position) { |n| "#{n} Operations Manager" }
  sequence(:contact_email) { |n| "email#{n}@example.com" }

  factory :contact do
    name
    position
    email
    avatar { fixture_file_upload(Rails.root.join('spec/fixtures/test_img_400x400.png'), 'image/png') }
  end

end
