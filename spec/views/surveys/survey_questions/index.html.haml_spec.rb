require 'rails_helper'

RSpec.describe "surveys/survey_questions/index", type: :view do
  before(:each) do
    @survey = FactoryGirl.create(:surveys_survey)
    assign(:surveys_survey_questions, [
      Surveys::SurveyQuestion.create!(
        :survey => @survey,
        :question => "MyText"
      ),
      Surveys::SurveyQuestion.create!(
        :survey => @survey,
        :question => "MyText"
      )
    ])
  end

  it "renders a list of surveys/survey_questions" do
    render
    assert_select "tr>td", :text => @survey.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
