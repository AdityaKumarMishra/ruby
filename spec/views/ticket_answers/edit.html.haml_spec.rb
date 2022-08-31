require 'rails_helper'

RSpec.describe "ticket_answers/edit", type: :view do
  before(:each) do
    @ticket_answer = assign(:ticket_answer, FactoryGirl.create(:ticket_answer))
  end

  it "renders the edit ticket_answer form" do
    render

    assert_select "form[action=?][method=?]", ticket_ticket_answer_path(@ticket_answer.ticket,@ticket_answer), "post" do

      assert_select "textarea#ticket_answer_content[name=?]", "ticket_answer[content]"

      assert_select "select#ticket_answer_ticket_id[name=?]", "ticket_answer[ticket_id]"

      assert_select "select#ticket_answer_user_id[name=?]", "ticket_answer[user_id]"

      assert_select "input#ticket_answer_public[name=?]", "ticket_answer[public]"

      assert_select "input#ticket_answer_helpfulness[name=?]", "ticket_answer[helpfulness]"
    end
  end
end
