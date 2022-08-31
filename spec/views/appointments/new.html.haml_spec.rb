require 'rails_helper'

RSpec.xdescribe "appointments/new", type: :view do
  before(:each) do
    assign(:appointment, Appointment.new(
      student: nil,
      tutor_availability: nil
    ))
  end

  it "renders new appointment form" do
    render

    assert_select "form[action=?][method=?]", appointments_path, "post" do

      assert_select "select#appointment_student_id[name=?]", "appointment[student_id]"

      assert_select "select#appointment_tutor_availability_id[name=?]", "appointment[tutor_availability_id]"
    end
  end
end
