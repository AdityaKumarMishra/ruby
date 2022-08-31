require 'rails_helper'

RSpec.describe "mcq_stems/edit", type: :view do
  login_superadmin
  let!(:user) {FactoryGirl.create(:user, email: "tt@gradready.com.au")}
  before(:each) do
    @mcq_stem = assign(:mcq_stem, FactoryGirl.create(McqStem))
    allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(FactoryGirl.create(:user), Tag))
  end

  it "renders the edit mcq_stem form" do
    render

    assert_select "form[action=?][method=?]", mcq_stem_path(@mcq_stem), "post" do

      assert_select "input#mcq_stem_title[name=?]", "mcq_stem[title]"

      assert_select "textarea#mcq_stem_description[name=?]", "mcq_stem[description]"
    end
  end
end
