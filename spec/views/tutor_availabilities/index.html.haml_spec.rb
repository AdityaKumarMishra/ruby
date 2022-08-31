require 'rails_helper'

RSpec.xdescribe "tutor_availabilities/index", type: :view do
  let(:tutor) { FactoryGirl.create(:user, :tutor) }
  let(:appointment) { FactoryGirl.create(:appointment) }
  let(:tutor_availability1) { FactoryGirl.create(:tutor_availability,
      repeatability: 1,
      start_time: DateTime.now.next_day(1) + 1.hour,
      end_time: DateTime.now.next_day(2) + 2.hour,
      location: "MyText1",
      tutor_profile: tutor.tutor_profile,
      available: true
  ) }
  let(:tutor_availability2) { FactoryGirl.create(:tutor_availability,
      repeatability: 1,
      start_time: DateTime.now.next_day(3) + 3.hour,
      end_time: DateTime.now.next_day(4) + 4.hour,
      location: "MyText2",
      tutor_profile: tutor.tutor_profile,
      available: false,
      appointment: appointment
  ) }
  before(:each) do
    assign(:available_appointments, [tutor_availability1] )
    assign(:booked_appointments, [tutor_availability2] )
  end

  it "renders a list of tutor_availabilities" do
    render
    assert_select "tr>td", text: tutor_availability2.appointment.student.to_s, :count => 1
    assert_select "tr>td", text: format_date_short(tutor_availability2.start_time.to_date), :count => 1
    assert_select "tr>td", text: format_time(tutor_availability2.start_time.time), :count => 1
    assert_select "tr>td", text: format_time(tutor_availability2.end_time.time), :count => 1
    assert_select "tr>td", text: tutor_availability2.location, :count => 1
    assert_select "tr>td", text: format_date_short(tutor_availability1.start_time.to_date), :count => 1
    assert_select "tr>td", text: format_time(tutor_availability1.start_time.time), :count => 1
    assert_select "tr>td", text: format_time(tutor_availability1.end_time.time), :count => 1
    assert_select "tr>td", text: tutor_availability1.location.to_s, :count => 1
  end
end
