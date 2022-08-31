require 'rails_helper'

RSpec.describe "ticket_answers/index", type: :view do
  before(:each) do
    assign(:ticket_answers, [
      FactoryGirl.create(:ticket_answer),
      FactoryGirl.create(:ticket_answer),
      FactoryGirl.create(:ticket_answer)
    ])
  end

  it "renders a list of ticket_answers" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 3
    assert_select "tr>td", :text => "MyString".to_s, :count => 3
    assert_select "tr>td", :text => "MyText".to_s, :count => 3
    assert_select "tr>td", :text => false.to_s, :count => 3
    assert_select "tr>td", :text => 0.to_s, :count => 3
  end
end
