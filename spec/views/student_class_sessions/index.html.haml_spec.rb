require 'rails_helper'

RSpec.describe "student_class_sessions/index", type: :view do
  before(:each) do
    @class = FactoryGirl.create(:student_class)
    assign(:student_class_sessions, [
      StudentClassSession.create!(
        :start_time => "2015-10-13",
        :end_time => "2015-10-13",
        :frequency => 1,
        :student_class => @class
      ),
      StudentClassSession.create!(
        :start_time => "2015-10-13",
        :end_time => "2015-10-13",
        :frequency => 1,
        :student_class => @class
      )
    ])
  end

  it "renders a list of student_class_sessions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => @class.to_s, :count => 2
  end
end
