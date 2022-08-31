require 'rails_helper'

RSpec.describe "surveys/survey_questions/show", type: :view do
  before(:each) do
    @surveys_survey_question = assign(:surveys_survey_question, FactoryGirl.create(:surveys_survey_question))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/MyTitle/)
  end
end
