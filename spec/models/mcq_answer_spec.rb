require 'rails_helper'

RSpec.describe McqAnswer, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:mcq_answer)).to be_valid
  end
  it {should belong_to(:mcq)}
  it {should validate_presence_of(:answer)}
  it { should have_many(:mcq_attempts) }

  describe '#fetch_answer_picked_percentage' do
    let!(:mcq_answer) { FactoryGirl.create(:mcq_answer) }
    let!(:mcq_attempt) { FactoryGirl.create(:mcq_attempt, mcq_answer_id: mcq_answer.id, mcq: mcq_answer.mcq) }
    it 'return user picked percantage' do
      mcq_answer.mcq.reload
      expect(mcq_answer.fetch_answer_picked_percentage).to eq(100)
    end
  end
end
