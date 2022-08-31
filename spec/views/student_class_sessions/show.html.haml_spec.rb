require 'rails_helper'

RSpec.describe "student_class_sessions/show", type: :view do
  before(:each) do
    @student_class_session = assign(:student_class_session, StudentClassSession.create!(
      :start_time => DateTime.current,
      :end_time => DateTime.current,
      :frequency => 1,
      :student_class => FactoryGirl.create(:student_class)
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
  end
end
