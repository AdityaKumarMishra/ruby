require 'rails_helper'

RSpec.describe "mcq_answers/index", type: :view do
  before(:each) do
    skip 'Need fix'
    mcq = FactoryGirl.create(:mcq)
    assign(:mcq_answers, [
      McqAnswer.create!(
        :answer => "MyText",
        :correct => false,
        :mcq => mcq
      ),
      McqAnswer.create!(
        :answer => "MyText",
        :correct => false,
        :mcq => mcq
      )
    ])
  end

  it "renders a list of mcq_answers" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
