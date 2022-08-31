require 'rails_helper'

RSpec.describe Exercise, type: :model do
  let(:student) { FactoryGirl.create :user, :student }
  let(:exercise) { FactoryGirl.create :exercise, user: student }

  it 'has many mcq_attempts' do
    expect(exercise).to have_many(:mcq_attempts)
  end

  it 'has many tags' do
    expect(exercise).to have_many(:tags)
  end

  it 'validates numeracity of difficulty' do
    expect(exercise).to define_enum_for(:difficulty).with([:easy, :medium, :hard, :mixed])
  end

  it 'validates numericality of amount ' do
    expect(exercise).to validate_numericality_of(:amount).only_integer
      .is_greater_than(0)
  end

  it 'validates presence of name' do
    expect(exercise).to validate_presence_of(:name)
  end

  it 'validates presence of difficulty' do
    expect(exercise).to validate_presence_of(:difficulty)
  end

  it 'validates presence of amonut' do
    expect(exercise).to validate_presence_of(:amount)
  end

  it 'validates presence of tags' do
    expect(exercise).to validate_presence_of(:tags)
  end

  # it 'validates uniquness of mcq_stem against exercise' do
  #   expect(exercise).to validate_uniqueness_of(:mcq_stem).scoped_to(:exercise_id)
  # end
  it 'accepts_nested_attributes_for taggings' do
    expect(exercise).to accept_nested_attributes_for(:taggings)
  end

  describe '#attempts_with_tag' do
    it 'should return attempts array with tag' do
      tag = exercise.tags.first
      expect(exercise.attempts_with_tag(tag)).to be_a_kind_of(ActiveRecord::AssociationRelation)
    end
  end

  describe '#time_taken_attempts_with_tag' do
    it 'should return attempt time of attempts_with_tag in Minute' do
      tag = exercise.tags.first
      mcq_stem = exercise.mcq_stems.first
      mcq = FactoryGirl.create(:mcq, mcq_stem: mcq_stem, tag: tag)
      mcq_attempt = FactoryGirl.create(:mcq_attempt, exercise: exercise, mcq_stem: mcq_stem, mcq: mcq)
      exercise.reload
      mcq_attempt = exercise.attempts_with_tag(tag).first
      mcq_stem = mcq_attempt.mcq_stem
      FactoryGirl.create(:mcq_attempt_time, mcq_stem_id: mcq_stem.id, sectionable: exercise, total_time: 60)
      expect(exercise.time_taken_attempts_with_tag(tag)).to eq('01 min 00 sec')
    end
  end

  describe '#mcq_stem_attempt_time' do
    it 'should return attempt time of mcq_stem in Minute' do
      mcq_stem = exercise.mcq_stems.first
      mcq = FactoryGirl.create(:mcq, mcq_stem: mcq_stem)
      FactoryGirl.create(:mcq_attempt_time, mcq_stem_id: mcq_stem.id, sectionable: exercise, total_time: 60)
      expect(exercise.mcq_stem_attempt_time(mcq_stem.id)).to eq(1.0)
    end
  end
end
