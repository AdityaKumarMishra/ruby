require 'rails_helper'

RSpec.xdescribe "mcq_student_answers/new", type: :view do
  before(:each) do
    assign(:mcq_student_answer, McqStudentAnswer.new(
      :title => "MyString",
      :description => "MyText",
      :mcq_answer => nil,
      :user => nil,
      :time_taken => 1
      ))
  end

  it "renders new mcq_student_answer form" do
    render

    assert_select "form[action=?][method=?]", mcq_student_answers_path, "post" do

      assert_select "input#mcq_student_answer_title[name=?]", "mcq_student_answer[title]"
      assert_select "textarea#mcq_student_answer_description[name=?]", "mcq_student_answer[description]"
      assert_select "input#mcq_student_answer_mcq_answer_id[name=?]", "mcq_student_answer[mcq_answer_id]"
      assert_select "input#mcq_student_answer_user_id[name=?]", "mcq_student_answer[user_id]"
      assert_select "input#mcq_student_answer_time_taken[name=?]", "mcq_student_answer[time_taken]"
    end
  end
end
