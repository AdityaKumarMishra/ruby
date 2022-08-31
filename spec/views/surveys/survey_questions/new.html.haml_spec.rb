require 'rails_helper'

RSpec.describe "surveys/survey_questions/new", type: :view do
  before(:each) do
    assign(:surveys_survey_question, Surveys::SurveyQuestion.new(
      :survey => FactoryGirl.create(:surveys_survey),
      :question => "MyText"
    ))
  end

  it "renders new surveys_survey_question form" do
    render

    assert_select "form[action=?][method=?]", surveys_survey_questions_path, "post" do

      assert_select "select#surveys_survey_question_survey_id[name=?]", "surveys_survey_question[survey_id]"

      assert_select "textarea#surveys_survey_question_question[name=?]", "surveys_survey_question[question]"
    end
  end
end
