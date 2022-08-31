require 'rails_helper'

RSpec.xdescribe "mcq_student_answers/index", type: :view do
  before(:each) do
    assign(:mcq_student_answers, [
      McqStudentAnswer.create!(
        :title => "Title",
        :description => "MyText",
        :mcq_answer => nil,
        :user => nil
      ),
      McqStudentAnswer.create!(
        :title => "Title",
        :description => "MyText",
        :mcq_answer => nil,
        :user => nil
      )
    ])
  end

  it "renders a list of mcq_student_answers" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
