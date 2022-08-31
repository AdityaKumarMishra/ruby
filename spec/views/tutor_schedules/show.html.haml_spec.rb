require 'rails_helper'

RSpec.xdescribe "tutor_schedules/show", type: :view do
  before(:each) do
    @tutor_schedule = assign(:tutor_schedule, TutorSchedule.create!(
      :repeatability => 1,
      :location => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
  end
end
