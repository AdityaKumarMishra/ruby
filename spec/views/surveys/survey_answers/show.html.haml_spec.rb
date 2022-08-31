require 'rails_helper'

RSpec.describe "surveys/survey_answers/show", type: :view do
  before(:each) do
    @surveys_survey_answer = assign(:surveys_survey_answer, Surveys::SurveyAnswer.create!(
      :user => FactoryGirl.create(:user, :student),
      :survey_question => FactoryGirl.create(:surveys_survey_question),
      :answer => "MyText",
      :rating => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
