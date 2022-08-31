require 'rails_helper'

RSpec.describe "surveys/survey_answers/edit", type: :view do
  before(:each) do
    @surveys_survey_answer = assign(:surveys_survey_answer, Surveys::SurveyAnswer.create!(
      :user => FactoryGirl.create(:user, :student),
      :survey_question => FactoryGirl.create(:surveys_survey_question),
      :answer => "MyText",
      :rating => 1
    ))
  end

  it "renders the edit surveys_survey_answer form" do
    render

    assert_select "form[action=?][method=?]", surveys_survey_answer_path(@surveys_survey_answer), "post" do

      assert_select "select#surveys_survey_answer_user_id[name=?]", "surveys_survey_answer[user_id]"

      assert_select "select#surveys_survey_answer_survey_question_id[name=?]", "surveys_survey_answer[survey_question_id]"

      assert_select "textarea#surveys_survey_answer_answer[name=?]", "surveys_survey_answer[answer]"

      assert_select "input#surveys_survey_answer_rating[name=?]", "surveys_survey_answer[rating]"
    end
  end
end
