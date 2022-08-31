require 'rails_helper'

RSpec.xdescribe "marks/show", type: :view do
  before(:each) do
    @mark = assign(:mark, Mark.create!(
      :value => 1.5,
      :correct => false,
      :user => nil,
      :essay_response => nil,
      :mcq_student_answer => nil,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
  end
end
