require 'rails_helper'

RSpec.xdescribe "appointments/edit", type: :view do
  before(:each) do
    @appointment = assign(:appointment, Appointment.create!(
        student_id: FactoryGirl.create(:user, :student),
        tutor_availability: FactoryGirl.create(:tutor_availability)
    ))
  end

  it "renders the edit appointment form" do
    render

    assert_select "form[action=?][method=?]", appointment_path(@appointment), "post" do

      assert_select "select#appointment_student_id[name=?]", "appointment[student_id]"

      assert_select "select#appointment_tutor_availability_id[name=?]", "appointment[tutor_availability_id]"
    end
  end
end
