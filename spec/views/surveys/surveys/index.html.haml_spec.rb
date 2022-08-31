require 'rails_helper'

RSpec.describe "surveys/surveys/index", type: :view do
  before(:each) do
    assign(:user, FactoryGirl.create(:user, :student))
    assign(:surveys_surveys, [
      Surveys::Survey.create!(
        :users => [FactoryGirl.create(:user, :tutor)],
        :title => "Title",
        :published => false,
        :date_start => DateTime.current,
        :date_closed => DateTime.current
      ),
      Surveys::Survey.create!(
        :users => [FactoryGirl.create(:user, :tutor)],
        :title => "Title",
        :published => false,
        :date_start => DateTime.current,
        :date_closed => DateTime.current
      )
    ])
  end

  it "renders a list of surveys/surveys" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
