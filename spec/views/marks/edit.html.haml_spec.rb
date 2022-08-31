require 'rails_helper'

RSpec.xdescribe "marks/edit", type: :view do
  before(:each) do
    @mark = assign(:mark, Mark.create!(
      :value => 1.5,
      :correct => false,
      :user => nil,
      :essay_response => nil,
      :mcq_student_answer => nil,
      :description => "MyString"
    ))
  end

  it "renders the edit mark form" do
    render

    assert_select "form[action=?][method=?]", mark_path(@mark), "post" do

      assert_select "input#mark_value[name=?]", "mark[value]"

      assert_select "input#mark_correct[name=?]", "mark[correct]"

      assert_select "input#mark_user_id[name=?]", "mark[user_id]"

      assert_select "input#mark_essay_response_id[name=?]", "mark[essay_response_id]"

      assert_select "input#mark_mcq_student_answer_id[name=?]", "mark[mcq_student_answer_id]"

      assert_select "input#mark_description[name=?]", "mark[description]"
    end
  end
end
