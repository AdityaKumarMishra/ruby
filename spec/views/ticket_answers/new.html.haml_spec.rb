require 'rails_helper'

RSpec.describe "ticket_answers/new", type: :view do
  before(:each) do
    @ticket = FactoryGirl.create(:ticket)
    assign(:ticket_answer, FactoryGirl.build(:ticket_answer))
  end

  it "renders new ticket_answer form" do
    render

    assert_select "form[action=?][method=?]", ticket_ticket_answers_path(@ticket), "post" do

      assert_select "textarea#ticket_answer_content[name=?]", "ticket_answer[content]"

      assert_select "select#ticket_answer_ticket_id[name=?]", "ticket_answer[ticket_id]"

      assert_select "select#ticket_answer_user_id[name=?]", "ticket_answer[user_id]"

      assert_select "input#ticket_answer_public[name=?]", "ticket_answer[public]"

      assert_select "input#ticket_answer_helpfulness[name=?]", "ticket_answer[helpfulness]"
    end
  end
end
