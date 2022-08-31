require 'rails_helper'

RSpec.describe ExamStatistic, type: :model do
  it { should belong_to(:tag) }
  it { should belong_to(:user) }
  it { should belong_to(:section_attempt) }

  describe '#taken_time' do
    exam_stat = FactoryGirl.create(:exam_statistic, total: 20, incorrect: 5, correct: 5, time_taken: 120)
    it 'should return time in min and sec' do
      expect(exam_stat.taken_time).to eq("02 min 00 sec")
    end
  end

  describe '#score' do
    exam_stat = FactoryGirl.create(:exam_statistic, total: 20, incorrect: 10, correct: 10, time_taken: 120)
    it 'should return score' do
      expect(exam_stat.score).to eq(50.0)
    end
  end
end
