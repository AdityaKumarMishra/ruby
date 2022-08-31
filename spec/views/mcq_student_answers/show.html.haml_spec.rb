require 'rails_helper'

RSpec.xdescribe "mcq_student_answers/show", type: :view do
  before(:each) do
    @mcq_student_answer = assign(:mcq_student_answer, McqStudentAnswer.create!(
      :title => "Title",
      :description => "MyText",
      :mcq_answer => nil,
      :user => nil,
      :time_taken => 1
      ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
  end
end
