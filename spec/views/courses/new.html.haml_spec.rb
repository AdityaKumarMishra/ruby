require 'rails_helper'

RSpec.describe "courses/new", type: :view do
  before(:each) do
    @product_version = FactoryGirl.create(:product_version)
    @user1= FactoryGirl.create(:user, :tutor)
    @staff1 = FactoryGirl.create(:staff_profile, staff: @user1)
    assign(:course, Course.new(
      :name => "MyString",
      :class_size => 1,
      :student_count => 1,
      :product_version_id => 1
    ))

  end

  xit "renders new course form" do

    render

    assert_select "form[action=?][method=?]", courses_path, "post" do

      assert_select "input#course_name[name=?]", "course[name]"

      assert_select "input#course_class_size[name=?]", "course[class_size]"

      assert_select "select#course_product_version_id[name=?]", "course[product_version_id]"
    end
  end
end
