require 'rails_helper'

RSpec.xdescribe "marks/index", type: :view do
  before(:each) do
    assign(:marks, [
      Mark.create!(
        :value => 1.5,
        :correct => false,
        :user => nil,
        :essay_response => nil,
        :mcq_student_answer => nil,
        :description => "Description"
      ),
      Mark.create!(
        :value => 1.5,
        :correct => false,
        :user => nil,
        :essay_response => nil,
        :mcq_student_answer => nil,
        :description => "Description"
      )
    ])
  end

  it "renders a list of marks" do
    render
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
