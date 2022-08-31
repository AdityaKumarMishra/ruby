require 'rails_helper'

xdescribe "course_versions/index", type: :view do
  before(:each) do
    assign(:course_versions, [
      CourseVersion.create!(
        :version_number => 1,
        :class_size => 2,
        :students_count => 3
      ),
      CourseVersion.create!(
        :version_number => 1,
        :class_size => 2,
        :students_count => 3
      )
    ])
  end

  it "renders a list of course_versions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
