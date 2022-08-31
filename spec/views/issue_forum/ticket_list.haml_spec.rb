require 'rails_helper'
RSpec.describe "issue_forum/show", type: :view do
  login_admin
  before(:each) do
    @question = FactoryGirl.create(:ticket)
  end
  
  it "renders and have asker full name" do
    render
    expect(rendered).to have_content(@question.asker_full_name)
  end
end