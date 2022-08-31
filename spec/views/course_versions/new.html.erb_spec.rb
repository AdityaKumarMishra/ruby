require 'rails_helper'

xdescribe "course_versions/new", type: :view do
  before(:each) do
    assign(:course_version, CourseVersion.new(
      :version_number => 1,
      :class_size => 1,
      :students_count => 1
    ))
  end

  it "renders new course_version form" do
    render

    assert_select "form[action=?][method=?]", course_versions_path, "post" do

      assert_select "input#course_version_version_number[name=?]", "course_version[version_number]"

      assert_select "input#course_version_class_size[name=?]", "course_version[class_size]"

      assert_select "input#course_version_students_count[name=?]", "course_version[students_count]"
    end
  end
end
