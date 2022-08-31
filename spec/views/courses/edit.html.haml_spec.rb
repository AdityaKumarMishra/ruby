require 'rails_helper'

RSpec.describe "courses/edit", type: :view do
  before(:each) do
    @product_version = FactoryGirl.create(:product_version)
    @course = assign(:course, Course.create!(
      :name => "MyString",
      :class_size => 1,
      :student_count => 1,
      :product_version_id => 1
    ))
  end

  xit "renders the edit course form" do
    render

    assert_select "form[action=?][method=?]", course_path(@course), "post" do

      assert_select "input#course_name[name=?]", "course[name]"

      assert_select "input#course_class_size[name=?]", "course[class_size]"

      assert_select "select#course_product_version_id[name=?]", "course[product_version_id]"
    end
  end
end
