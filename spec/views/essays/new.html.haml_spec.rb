require 'rails_helper'

RSpec.describe "essays/new", type: :view do
  before(:each) do
    assign(:essay, Essay.new(
      :title => "MyString",
      :question => "MyText",
      :tutor => FactoryGirl.create(:user, :tutor),
      :student => nil
    ))
  end

  xit "renders new essay form" do
    render

    assert_select "form[action=?][method=?]", essays_path, "post" do

      assert_select "input#essay_title[name=?]", "essay[title]"

      assert_select "textarea#essay_question[name=?]", "essay[question]"
    end
  end
end
