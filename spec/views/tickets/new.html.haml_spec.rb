require 'rails_helper'

RSpec.describe "tickets/new", type: :view do
  before(:each) do
    assign(:ticket, Ticket.new(
      :title => "MyString",
      :question => "MyText",
      :asker => nil,
      :answerer => nil,
      :public => false,
      :questionable => nil
    ))
  end

  xit "renders new ticket form" do
    render

    assert_select "form[action=?][method=?]", tickets_path, "post" do

      assert_select "input#ticket_title[name=?]", "ticket[title]"

      assert_select "textarea#ticket_question[name=?]", "ticket[question]"

      assert_select "input#ticket_asker_id[name=?]", "ticket[asker_id]"

      assert_select "input#ticket_answerer_id[name=?]", "ticket[answerer_id]"

      assert_select "input#ticket_public[name=?]", "ticket[public]"

      assert_select "input#ticket_questionable_id[name=?]", "ticket[questionable_id]"
    end
  end
end
