require 'rails_helper'

RSpec.xdescribe "tutor_schedules/edit", type: :view do
  before(:each) do
    @tutor_schedule = assign(:tutor_schedule, TutorSchedule.create!(
      :repeatability => 1,
      :location => "MyText"
    ))
  end

  it "renders the edit tutor_schedule form" do
    render

    assert_select "form[action=?][method=?]", tutor_schedule_path(@tutor_schedule), "post" do

      assert_select "input#tutor_schedule_repeatability[name=?]", "tutor_schedule[repeatability]"

      assert_select "textarea#tutor_schedule_location[name=?]", "tutor_schedule[location]"
    end
  end
end
