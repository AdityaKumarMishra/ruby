require 'rails_helper'

RSpec.describe "student_class_sessions/new", type: :view do
  before(:each) do
    assign(:student_class_session, StudentClassSession.new(
      :frequency => 1,
      :student_class => FactoryGirl.create(:student_class)
    ))
  end

  it "renders new student_class_session form" do
    render

    assert_select "form[action=?][method=?]", student_class_sessions_path, "post" do

      assert_select "input#student_class_session_frequency[name=?]", "student_class_session[frequency]"

      assert_select "select#student_class_session_student_class_id[name=?]", "student_class_session[student_class_id]"
    end
  end
end
