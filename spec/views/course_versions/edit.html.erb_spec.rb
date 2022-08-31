require 'rails_helper'

xdescribe "course_versions/edit", type: :view do
  before(:each) do
    @course_version = assign(:course_version, CourseVersion.create!(
      :version_number => 1,
      :class_size => 1,
      :students_count => 1
    ))
  end

  it "renders the edit course_version form" do
    render

    assert_select "form[action=?][method=?]", course_version_path(@course_version), "post" do

      assert_select "input#course_version_version_number[name=?]", "course_version[version_number]"

      assert_select "input#course_version_class_size[name=?]", "course_version[class_size]"

      assert_select "input#course_version_students_count[name=?]", "course_version[students_count]"
    end
  end
end
