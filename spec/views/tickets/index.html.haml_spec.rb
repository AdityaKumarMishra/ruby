require 'rails_helper'

RSpec.describe "tickets/index", type: :view do
  before(:each) do
    assign(:tickets, [
      Ticket.create!(
        :title => "Title",
        :question => "MyText",
        :asker => nil,
        :answerer => nil,
        :public => false,
        :questionable => nil
      ),
      Ticket.create!(
        :title => "Title",
        :question => "MyText",
        :asker => nil,
        :answerer => nil,
        :public => false,
        :questionable => nil
      )
    ])
  end

  xit "renders a list of tickets" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
