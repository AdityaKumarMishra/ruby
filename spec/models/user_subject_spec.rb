# == Schema Information
#
# Table name: user_subjects
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  active_subject_id :integer
#

require 'rails_helper'

RSpec.describe UserSubject, type: :model do
  subject(:user_subject) { FactoryGirl.build(:user_subject) }

  it 'has valid :user_subject factory' do
    expect(user_subject).to be_valid
  end

  it { expect(user_subject).to belong_to :user }
  it { expect(user_subject).to belong_to :subject }

  it { expect(user_subject).to validate_presence_of :user_id }
  it { expect(user_subject).to validate_presence_of :active_subject_id }
end
