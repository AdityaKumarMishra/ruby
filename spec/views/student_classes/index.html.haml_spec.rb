require 'rails_helper'

RSpec.describe "student_classes/index", type: :view do
  before(:each) do
    @subject = FactoryGirl.create(:subject)
    assign(:student_classes, [
      StudentClass.create!(
        :name => "Name",
        :size => 1,
        :subject => @subject
      ),
      StudentClass.create!(
        :name => "Name",
        :size => 1,
        :subject => @subject
      )
    ])
  end

  it "renders a list of student_classes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => @subject.to_s, :count => 2
  end
end
