require 'rails_helper'

RSpec.describe ExercisesHelper, type: :helper do
  describe '#get_difficulties' do
    it 'should not raise an error' do
      expect { get_difficulties }.not_to raise_error
    end
  end

  describe '#total_mcq_by_tag' do
    let!(:mcq_stem) { FactoryGirl.create(:mcq_stem) }
    let!(:tag) { FactoryGirl.create :tag }
    let!(:mcq) do
      FactoryGirl.create(:mcq, mcq_stem_id: mcq_stem.to_param,
                               mcq_answers_attributes: [{ answer: 'MyText', correct: true }],
                               tagging_attributes: { tag_id: tag.id })
    end
    let!(:user) {FactoryGirl.create :user}
    let!(:statistics) {Tag.mcq_statistics(user, Tag.all)}

    it 'should return published mcq count by tag' do
      expect(total_mcq_by_tag(statistics, tag)).to eq(1)
    end
  end

  describe '#tag_level_padding' do
    it 'should return tag-level1-padding if level is 1' do
      level = 1
      expect(tag_level_padding(level)).to eq('tag-level1-padding')
    end

    it 'should return tag-level2-padding if level is 2' do
      level = 2
      expect(tag_level_padding(level)).to eq('tag-level2-padding')
    end

    it 'should return empty string if level is not 1 or 2' do
      level = 5
      expect(tag_level_padding(level)).to eq('')
    end
  end
end
