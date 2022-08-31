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

require 'rails_helper'

RSpec.describe McqHour, type: :model do
  context 'scopes' do
    let!(:tutor) { FactoryGirl.create(:user, :tutor) }

    context 'when range scopes' do
      let!(:mcq_hour1) { FactoryGirl.create(:mcq_hour, user_id: tutor.id, created_at: '2022-07-03T08:59:59') }
      let!(:mcq_hour2) { FactoryGirl.create(:mcq_hour, user_id: tutor.id, created_at: '2022-07-04T15:00:00') }
      let!(:mcq_hour3) { FactoryGirl.create(:mcq_hour, user_id: tutor.id, created_at: '2022-07-07T00:00:00') }
      let!(:mcq_hour4) { FactoryGirl.create(:mcq_hour, user_id: tutor.id, created_at: '2022-07-17T11:59:59') }
      let!(:mcq_hour5) { FactoryGirl.create(:mcq_hour, user_id: tutor.id, created_at: '2022-07-18T15:00:00') }

      context 'with created_with_start' do
        it 'returns correct result set' do
          expect(McqHour.created_with_start('2022-07-04').pluck(:id).sort).to(
            eq([mcq_hour2.id, mcq_hour3.id, mcq_hour4.id, mcq_hour5.id])
          )
        end
      end

      context 'with created_with_end' do
        it 'returns correct result set' do
          expect(McqHour.created_with_end('2022-07-17').pluck(:id).sort).to(
            eq([mcq_hour1.id, mcq_hour2.id, mcq_hour3.id, mcq_hour4.id])
          )
        end
      end

      context 'with created_with_start and created_with_end' do
        it 'returns correct result set' do
          expect(McqHour.created_with_start('2022-07-04').created_with_end('2022-07-17').pluck(:id).sort).to(
            eq([mcq_hour2.id, mcq_hour3.id, mcq_hour4.id])
          )
        end
      end
    end
  end

  context 'validations' do
    it 'should not be saveable without hours, logging type, user_id, and mcq_stem_id' do
      hour = McqHour.create(hours: nil, logging_type: nil, user_id: nil, mcq_stem_id: nil)
      expect(hour).not_to be_valid
      hour.errors.should have_key(:hours)
      hour.errors.should have_key(:logging_type)
      hour.errors.should have_key(:user)
      hour.errors.should have_key(:mcq_stem)
    end
  end
end
