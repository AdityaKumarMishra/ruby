require 'rails_helper'

RSpec.xdescribe "tutor_schedules/index", type: :view do
  before(:each) do
    assign(:tutor_schedules, [
      TutorSchedule.create!(
        :repeatability => 1,
        :location => "MyText"
      ),
      TutorSchedule.create!(
        :repeatability => 1,
        :location => "MyText"
      )
    ])
  end

  it "renders a list of tutor_schedules" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    expect(render).to match(/Listing Tutor Schedules/)
  end
end
