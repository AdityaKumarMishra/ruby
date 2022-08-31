require 'rails_helper'

RSpec.xdescribe "appointments/show", type: :view do
  before(:each) do
    @tutor = FactoryGirl.create(:user, :tutor)
    @tutor_availability = FactoryGirl.create(:tutor_availability)
    @tutor.tutor_profile.tutor_availabilities << @tutor_availability
    @student = FactoryGirl.create(:user, :student)
    @appointment = assign(:appointment, FactoryGirl.create(:appointment,
        :student => @student,
        :tutor_availability => @tutor_availability
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to have_content(@appointment.location)
    expect(rendered).to have_content(@appointment.location)
    expect(rendered).to have_content(@appointment.location)
  end
end
