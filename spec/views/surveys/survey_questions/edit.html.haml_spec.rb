require 'rails_helper'

RSpec.describe "surveys/survey_questions/edit", type: :view do
  before(:each) do
    @surveys_survey_question = assign(:surveys_survey_question, Surveys::SurveyQuestion.create!(
      :survey => FactoryGirl.create(:surveys_survey),
      :question => "MyText"
    ))
  end

  it "renders the edit surveys_survey_question form" do
    render

    assert_select "form[action=?][method=?]", surveys_survey_question_path(@surveys_survey_question), "post" do

      assert_select "select#surveys_survey_question_survey_id[name=?]", "surveys_survey_question[survey_id]"

      assert_select "textarea#surveys_survey_question_question[name=?]", "surveys_survey_question[question]"
    end
  end
end
