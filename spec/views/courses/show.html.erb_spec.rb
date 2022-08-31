require 'rails_helper'

RSpec.describe "courses/show", type: :view do
  before(:each) do
    @course = assign(:course, FactoryGirl.create(:course))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to have_content(@course.name)
  end
end
