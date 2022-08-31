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

require 'rails_helper'

RSpec.describe TutorProfile, type: :model do
  it 'should have valid factory' do
    expect(FactoryGirl.build(:tutor_profile)).to be_valid
  end

  it { should have_many(:tutor_availabilities) }
  it { should belong_to(:tutor) }

end
