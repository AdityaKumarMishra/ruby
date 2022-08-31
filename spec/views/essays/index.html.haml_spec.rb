require 'rails_helper'

RSpec.describe "essays/index", type: :view do
  before(:each) do
    @tutor = FactoryGirl.create(:user, :tutor)
    @student = FactoryGirl.create(:user, :student)
    assign(:essays, [
      Essay.create!(
        :title => "Title",
        :question => "MyQuestion",
        :tutor => @tutor,
        :student => @student
      ),
      Essay.create!(
        :title => "Title",
        :question => "MyQuestion",
        :tutor => @tutor,
        :student => @student
      )
    ])
  end

  xit "renders a list of essays" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyQuestion".to_s, :count => 2
    assert_select "tr>td", :text => @tutor.to_s, :count => 2
    assert_select "tr>td", :text => @student.to_s, :count => 2
    it { should have_select('#has_answered_filter')}
    it { should have_select('#tag_filter')}
  end
end
