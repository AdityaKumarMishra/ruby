require 'rails_helper'

RSpec.xdescribe "tutor_availabilities/show", type: :view do
  before(:each) do
    @tutor_availability = assign(:tutor_availability, FactoryGirl.create(:tutor_availability))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Dec 24/)
    expect(rendered).to match(/09:29/)
    expect(rendered).to match(/10:29/)
    expect(rendered).to match(/MyText/)
  end
end
