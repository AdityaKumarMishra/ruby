require 'rails_helper'

RSpec.describe McqStatistic, type: :model do
  it { should belong_to(:tag) }
  it { should belong_to(:user) }

  describe '#update_score_and_used_percentage' do
    mcq_stat = FactoryGirl.create(:mcq_statistic, total: 20, viewed: 10, correct: 5)
    it 'should update score and used percentage' do
      mcq_stat.update_score_and_used_percentage
      expect(mcq_stat.used).to eq(50.0)
      expect(mcq_stat.score).to eq(50.0)
    end
  end
end
