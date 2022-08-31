require 'rails_helper'

RSpec.describe "surveys/survey_answers/new", type: :view do
  before(:each) do
    assign(:surveys_survey_answer, Surveys::SurveyAnswer.new(
      :user => FactoryGirl.create(:user, :student),
      :survey_question => FactoryGirl.create(:surveys_survey_question),
      :answer => "MyText",
      :rating => 1
    ))
  end

  it "renders new surveys_survey_answer form" do
    render

    assert_select "form[action=?][method=?]", surveys_survey_answers_path, "post" do

      assert_select "select#surveys_survey_answer_user_id[name=?]", "surveys_survey_answer[user_id]"

      assert_select "select#surveys_survey_answer_survey_question_id[name=?]", "surveys_survey_answer[survey_question_id]"

      assert_select "textarea#surveys_survey_answer_answer[name=?]", "surveys_survey_answer[answer]"

      assert_select "input#surveys_survey_answer_rating[name=?]", "surveys_survey_answer[rating]"
    end
  end
end
