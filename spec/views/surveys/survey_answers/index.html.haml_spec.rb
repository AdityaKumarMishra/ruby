require 'rails_helper'

RSpec.describe "surveys/survey_answers/index", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user, :student)
    @survey_question = FactoryGirl.create(:surveys_survey_question)

    assign(:surveys_survey_answers, [
      Surveys::SurveyAnswer.create!(
        :user => @user,
        :survey_question => @survey_question,
        :answer => "MyText",
        :rating => 1
      ),
      Surveys::SurveyAnswer.create!(
        :user => @user,
        :survey_question => @survey_question,
        :answer => "MyText",
        :rating => 1
      )
    ])
  end

  it "renders a list of surveys/survey_answers" do
    render
    assert_select "tr>td", :text => @user.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
