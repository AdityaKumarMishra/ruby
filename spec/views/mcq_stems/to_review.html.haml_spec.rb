require 'rails_helper'

RSpec.describe 'mcq_stems/to_review', type: :view do
  let(:user) { FactoryGirl.create(:user) }
  before(:each) do
    sign_in user

    @mcq_stem = assign(:mcq_stem, FactoryGirl.create(McqStem))
    @mcq_stems = assign(:mcq_stems, [
      FactoryGirl.create(McqStem),
      FactoryGirl.create(McqStem)])
  end

  it 'renders a list of mcq_stems to review' do
    expect { render }.not_to raise_error
  end

  it "if reviewer is present" do
    reviewer = assign(:user, FactoryGirl.create(:user, first_name: "test", last_name: "user") )
    mcq_stem1 = assign(:mcq_stem, FactoryGirl.create(McqStem))
    mcq_stem1.reviewer_id = reviewer.id
    expect(mcq_stem1.reviewer.full_name).to eq("test user")
  end

  it "if reviewer is not present" do
    mcq_stem2 = assign(:mcq_stem, FactoryGirl.create(McqStem))
    mcq_stem2.reviewer_id = ""
    expect { render }.not_to raise_error
  end
end

