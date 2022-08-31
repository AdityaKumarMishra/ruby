require 'rails_helper'

RSpec.xdescribe "essays/edit", type: :view do
  before(:each) do
    @essay = assign(:essay, Essay.create!(
      :title => "MyString",
      :question => "MyText",
      :tutor => FactoryGirl.create(:user, :tutor),
      :student => nil
    ))
  end

  it "renders the edit essay form" do
    render

    assert_select "form[action=?][method=?]", essay_path(@essay), "post" do

      assert_select "input#essay_title[name=?]", "essay[title]"

      assert_select "textarea#essay_question[name=?]", "essay[question]"

      assert_select "select#essay_student_id[name=?]", "essay[student_id]"
    end
  end
end
