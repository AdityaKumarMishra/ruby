require 'rails_helper'

RSpec.describe "surveys/surveys/new", type: :view do
  before(:each) do
    assign(:surveys_survey, Surveys::Survey.new(
        :users => [FactoryGirl.create(:user, :tutor)],
        :title => "MyString",
        :published => false,
        :date_start => DateTime.current,
        :date_closed => DateTime.current
    ))
  end

  it "renders new surveys_survey form" do
    render

    assert_select "form[action=?][method=?]", surveys_surveys_path, "post" do
      assert_select "select#surveys_survey_user_ids[name=?]", "surveys_survey[user_ids][]"
      assert_select "input#surveys_survey_title[name=?]", "surveys_survey[title]"
      assert_select "input#surveys_survey_published[name=?]", "surveys_survey[published]"
    end
  end
end
