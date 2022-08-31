require 'rails_helper'

RSpec.describe "surveys/surveys/edit", type: :view do
  before(:each) do
    @surveys_survey = assign(:surveys_survey, FactoryGirl.create(:surveys_survey))
  end

  it "renders the edit surveys_survey form" do
    render

    assert_select "form[action=?][method=?]", surveys_survey_path(@surveys_survey), "post" do

    end
  end
end
