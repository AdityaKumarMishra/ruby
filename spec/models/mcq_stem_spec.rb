# == Schema Information
#
# Table name: mcq_stems
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tag_id      :integer
#  author_id   :integer
#  student_id  :integer
#

require 'rails_helper'

RSpec.describe McqStem, type: :model do
  subject(:mcq_stem) { FactoryGirl.build(:mcq_stem) }
  let(:user) { FactoryGirl.create :user }
  let(:mcq_stem) { FactoryGirl.create :mcq_stem }
  it { should have_many(:mcq_attempts).dependent(:destroy) }
  it { should have_many(:section_items) }

  context 'scopes' do
    it "should return mcq stems by author id" do
      McqStem.with_author_id(user.id) == McqStem.where(author_id: user.id)
    end
    it "Should return not reviewed mcq_stems" do
      McqStem.with_reviewer_id("Not Reviewed") == McqStem.where(reviewed: false)
    end
    it "Should return reviewed mcq_stems" do
      McqStem.with_reviewer_id("Reviewed") == McqStem.where(reviewed: true)
    end
    it "should return mcq stems by reviewer_id" do
      McqStem.with_reviewer_id(user.id) == McqStem.where(reviewer_id: user.id)
    end
    it "should return mcq stems by author id" do
      McqStem.published == McqStem.where(published: true)
    end
    it "should return non published mcq stems" do
      McqStem.non_published == McqStem.where(published: false)
    end
    it "should return non examinable mcq stems" do
      McqStem.non_examinable == McqStem.where(examinable: false)
    end
    it "should return examinable mcq stems" do
      McqStem.examinable == McqStem.where(examinable: true)
    end
  end

  context 'validations' do
    it 'should not be able to be published without being reviewd' do
      stem = McqStem.create(published: true, reviewed: false)
      stem.valid?
      stem.errors.should have_key(:published)
    end
  end
  describe '#has_access?' do
    it 'should return false if user is student' do
      expect(mcq_stem.has_access?(user)).to eq false
    end
  end

  describe '#name_human' do
    it 'should return human name for mcq_stem' do
      mcq_stem = FactoryGirl.create(:mcq_stem)
      expect(mcq_stem.name_human).to eq('Mcq Stem')
    end
  end
end
