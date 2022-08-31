require 'rails_helper'

RSpec.describe "student_class_sessions/edit", type: :view do
  before(:each) do
    @student_class_session = assign(:student_class_session, StudentClassSession.create!(
      :start_time => "2015-10-13",
      :end_time => "2015-10-13",
      :frequency => 1,
      :student_class => FactoryGirl.create(:student_class)
    ))
  end

  it "renders the edit student_class_session form" do
    render

    assert_select "form[action=?][method=?]", student_class_session_path(@student_class_session), "post" do

      assert_select "input#student_class_session_frequency[name=?]", "student_class_session[frequency]"

      assert_select "select#student_class_session_student_class_id[name=?]", "student_class_session[student_class_id]"
    end
  end
end
