# == Schema Information
#
# Table name: enrolments
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  new_course_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Enrolment, type: :model do
  let(:enrolment) { FactoryGirl.create :enrolment }
  let(:trial_enrolment) { FactoryGirl.create :enrolment, trial: true, trial_expiry: Time.zone.now + 1.days }
  it 'validates presence of course' do
    expect(enrolment).to validate_presence_of(:course)
  end

  it 'validates presence of trial_expiry if trial enrolment' do
    expect(trial_enrolment).to validate_presence_of(:trial_expiry)
  end

  describe '#destroy' do
    it 'does not check payment' do
      expect(enrolment).not_to receive(:check_payment)
      enrolment.destroy
    end
  end

  describe '#trial_expired?' do
    context 'When enrolment is a trial and trial is expired' do
      it 'should return true' do
        trial_enrolment.trial_expiry = Time.zone.now - 1.second
        expect(trial_enrolment.trial_expired?).to eq true
      end
    end
    context 'When enrolment is a trial and trial is not expired' do
      it 'should return false' do
        expect(trial_enrolment.trial_expired?).to eq false
      end
    end
    context 'When enrolment is a non trial' do
      it 'should return nil' do
        expect(enrolment.trial_expired?).to eq nil
      end
    end
  end

  describe '#extend_free_trial' do
    context 'When enrolment is a trial' do
      it 'should extend the free trial by 1 day' do
        trial_period = trial_enrolment.trial_expiry
        trial_enrolment.extend_free_trial(1)
        expect(trial_enrolment.trial_expiry).to eq (trial_period + 1.day)
      end
    end
    context 'When enrolment is a non trial' do
      it 'should not change the trial_expiry' do
        trial_period = enrolment.trial_expiry
        enrolment.extend_free_trial(1)
        expect(enrolment.trial_expiry).to eq trial_period
      end
    end
  end
end
