require 'rails_helper'

xdescribe "course_versions/show", type: :view do
  before(:each) do
    @course_version = assign(:course_version, CourseVersion.create!(
      :version_number => 1,
      :class_size => 2,
      :students_count => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
