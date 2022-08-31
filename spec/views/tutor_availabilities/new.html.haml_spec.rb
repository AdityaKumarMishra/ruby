require 'rails_helper'

RSpec.xdescribe "tutor_availabilities/new", type: :view do
  before(:each) do
    assign(:tutor_availability, TutorAvailability.new(
        repeatability: 1,
        start_time: DateTime.now.next_day(1),
        end_time: DateTime.now.next_day(2),
        location: "MyText1",
    ))
  end

  it "renders new tutor_availability form" do
    render

    assert_select "form[action=?][method=?]", tutor_availabilities_path, "post" do

      assert_select "select#tutor_availability_repeatability[name=?]", "tutor_availability[repeatability]"
      assert_select "input#tutor_availability_start_time[name=?]", "tutor_availability[start_time]"
      assert_select "input#tutor_availability_end_time[name=?]", "tutor_availability[end_time]"
      assert_select "textarea#tutor_availability_location[name=?]", "tutor_availability[location]"

    end
  end
end
