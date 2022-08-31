require 'rails_helper'

RSpec.describe "surveys/surveys/show", type: :view do
  before(:each) do
    @surveys_survey = assign(:surveys_survey,FactoryGirl.create(:surveys_survey))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/false/)
  end
end
