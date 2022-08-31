require 'rails_helper'

RSpec.describe Tag, type: :model do
  tag = FactoryGirl.create :tag

  it 'validates uniqueness of name' do
    expect(tag).to validate_uniqueness_of(:name)
  end

  it { should have_many(:essays).through(:taggings) }

  # it 'cannot be itself parent' do
  #   expect(tag).not_to allow_value(tag.id).for(:parent_id)
  # end

  context 'scopes' do
    it "should return level one tags" do
      Tag.level_one == Tag.where(parent_id: nil)
    end

    it "should return level one tags except pt public tag" do
      Tag.level_one_exclude_pt_public == Tag.level_one.where.not(id: 253)
    end
  end
  describe ".overseeing_receivers_for_tags" do
    let(:tag_lv1) {
      FactoryGirl.create(:tag,overseeing_users:[FactoryGirl.create(:user, email: "xxx1@555.com")])
    }
    let(:tag_lv2) {
      FactoryGirl.create(:tag,parent:tag_lv1,
        overseeing_users:[FactoryGirl.create(:user, email: "xxx2@555.com")])
    }
    let(:tag_lv3) {
      FactoryGirl.create(:tag,parent:tag_lv2,
        overseeing_users:[FactoryGirl.create(:user, email: "xxx3@555.com")])
    }

    it "returns relevant overseeing staff emails" do
      expect(Tag.overseeing_receivers_for_tags([tag_lv3])).to match_array(["xxx3@555.com","xxx2@555.com","xxx1@555.com"])
    end

  end

  describe "#published_and_non_published_mcq_stem" do
    let!(:mcq_stem) {FactoryGirl.create(:mcq_stem, published: true)}
    let!(:tag_lv4) {FactoryGirl.create(:tag)}
    let!(:tagging) {FactoryGirl.create(:tagging, tag_id: tag_lv4.id, taggable_id: mcq_stem.id, taggable_type: "McqStem")}
    let!(:published_mcq_stem) { mcq_stem.id}
    it 'should return question count for mcq of published mcq_stem' do
      expect(tag_lv4.published_and_non_published_mcq_stem("Published")).to match_array(published_mcq_stem)
    end
  end

end
