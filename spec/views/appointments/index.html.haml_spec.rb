require 'rails_helper'

RSpec.xdescribe "appointments/index", type: :view do
  before(:each) do
    @tutor = FactoryGirl.create(:user, :tutor)
    @tutor_availability = FactoryGirl.create(:tutor_availability)
    @tutor.tutor_profile.tutor_availabilities << @tutor_availability
    @student = FactoryGirl.create(:user, :student)
    assign(:appointments, [
      FactoryGirl.create(:appointment,
                         student: @student,
                         tutor_availability: @tutor_availability
      ),
      FactoryGirl.create(:appointment,
                         student: @student,
                         tutor_availability: @tutor_availability
    )
    ])
  end

  it "renders a list of appointments" do
    render
    assert_select "tr>td", text: @tutor_availability.tutor.to_s, :count => 2
    assert_select "tr>td", text: @tutor_availability.location.to_s, :count => 2
  end
end
