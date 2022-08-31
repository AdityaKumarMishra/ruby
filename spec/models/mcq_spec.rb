require 'rails_helper'

RSpec.describe Mcq, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:mcq)).to be_valid
  end
  it { should have_many(:mcq_answers)}
  it { should have_many(:section_items).dependent(:nullify) }
  it {should validate_presence_of(:question)}
  it {should validate_presence_of(:difficulty)}
  it {should validate_presence_of(:explanation)}

  it {should validate_numericality_of(:difficulty).is_greater_than 0}
  # non-boolean get automatically converted to boolean
  # it {should validate_inclusion_of(:examinable).in_array([true,false])}
  # it {should validate_inclusion_of(:publish).in_array([true,false])}

  describe 'name_human' do
    let!(:mcq) {FactoryGirl.create(:mcq)}
    it 'should return title' do
      expect(mcq.mcq_stem.title)
    end
  end

  describe '#published' do
    let!(:mcq) {FactoryGirl.create(:mcq)}
    it 'should return mcq_stem published for mcqs' do
      expect(mcq.mcq_stem.published)
    end
  end

  describe '#fetch_difficulity' do
    let!(:mcq) {FactoryGirl.create(:mcq)}
    it 'should retrun difficulty of mcq' do
      expect(mcq.fetch_difficulity).to eq(1)
    end
  end
end
