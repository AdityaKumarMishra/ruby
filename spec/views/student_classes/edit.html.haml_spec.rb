require 'rails_helper'

RSpec.describe "student_classes/edit", type: :view do
  before(:each) do
    @student_class = assign(:student_class, StudentClass.create!(
      :name => "MyString",
      :size => 1,
      :subject => FactoryGirl.create(:subject)
    ))
  end

  it "renders the edit student_class form" do
    render

    assert_select "form[action=?][method=?]", student_class_path(@student_class), "post" do

      assert_select "input#student_class_name[name=?]", "student_class[name]"

      assert_select "input#student_class_size[name=?]", "student_class[size]"

      assert_select "select#student_class_active_subject_id[name=?]", "student_class[active_subject_id]"
    end
  end
end
