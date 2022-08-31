require 'rails_helper'

RSpec.describe SectionAttempt, type: :model do
  let(:section) { FactoryGirl.create :section }
  let(:assessment_attempt) { FactoryGirl.create :assessment_attempt, assessable: section.sectionable }
  let(:sa) do
    FactoryGirl.create(:section_attempt, section: section,
                                         assessment_attempt: assessment_attempt,
                                         mark: 2)
  end

  it 'validates presence of user' do
    expect(sa).to validate_presence_of(:user)
  end

  it 'validates presence of section' do
    expect(sa).to validate_presence_of(:section)
  end

  it 'validates presence of assessment_attempt' do
    expect(sa).to validate_presence_of(:assessment_attempt)
  end

  it 'calculate corret precentile' do
    sa2 = FactoryGirl.create(:section_attempt, section: section,
                                               assessment_attempt: assessment_attempt,
                                               mark: 2)
    sa_nc = FactoryGirl.create(:section_attempt, section: section,
                                                 assessment_attempt: assessment_attempt,
                                                 mark: 2, completed_at: nil)
    sa4 = FactoryGirl.create(:section_attempt, section: section,
                                               assessment_attempt: assessment_attempt,
                                               mark: 4)
    sa6 = FactoryGirl.create(:section_attempt, section: section,
                                               assessment_attempt: assessment_attempt,
                                               mark: 6)
    sa6_2 = FactoryGirl.create(:section_attempt, section: section,
                                                 assessment_attempt: assessment_attempt,
                                                 mark: 6)
    sa8 = FactoryGirl.create(:section_attempt, section: section,
                                               assessment_attempt: assessment_attempt,
                                               mark: 8)
    sa8_2 = FactoryGirl.create(:section_attempt, section: section,
                                                 assessment_attempt: assessment_attempt,
                                                 mark: 8)

    sa10 = FactoryGirl.create(:section_attempt, section: section,
                                                assessment_attempt: assessment_attempt,
                                                mark: 10)
    sa10_2 = FactoryGirl.create(:section_attempt, section: section,
                                                  assessment_attempt: assessment_attempt,
                                                  mark: 10)
    section.calculate_percentile
    sa2.reload
    expect(sa2.percentile).to eq 6.25
    sa4.reload
    expect(sa4.percentile).to eq 18.75
    sa6.reload
    expect(sa6.percentile).to eq 37.5
    sa6_2.reload
    expect(sa6_2.percentile).to eq 37.5
    sa8.reload
    expect(sa8.percentile).to eq 62.5
    sa10.reload
    expect(sa10.percentile).to eq 87.5
    sa8_2.reload
    expect(sa8_2.percentile).to eq 62.5
    sa10_2.reload
    expect(sa10_2.percentile).to eq 87.5
  end

  describe '#mcq_stem_attempt_time' do
    it 'should return attempt time of mcq_stem in Minute' do
      mcq_stem = FactoryGirl.create(:mcq_stem)
      mcq = FactoryGirl.create(:mcq, mcq_stem: mcq_stem)
      mcq_answer = mcq.mcq_answers.first
      FactoryGirl.create(:section_item_attempt, section_attempt: sa, mcq_stem: mcq_stem, mcq: mcq, mcq_answer: mcq_answer)
      FactoryGirl.create(:mcq_attempt_time, mcq_stem_id: mcq_stem.id, sectionable: sa, total_time: 60)
      expect(sa.mcq_stem_attempt_time(mcq_stem.id)).to eq('01 min 00 sec')
    end
  end
end
