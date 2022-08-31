require 'rails_helper'

RSpec.xdescribe "tutor_schedules/new", type: :view do
  before(:each) do
    assign(:tutor_schedule, TutorSchedule.new(
      :repeatability => 1,
      :location => "MyText"
    ))
  end

  it "renders new tutor_schedule form" do
    render

    assert_select "form[action=?][method=?]", tutor_schedules_path, "post" do

      assert_select "input#tutor_schedule_repeatability[name=?]", "tutor_schedule[repeatability]"

      assert_select "textarea#tutor_schedule_location[name=?]", "tutor_schedule[location]"
    end
  end
end
