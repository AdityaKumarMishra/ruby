require 'rails_helper'

RSpec.describe "ticket_answers/show", type: :view do
  before(:each) do
    @ticket_answer = assign(:ticket_answer, FactoryGirl.create(:ticket_answer))
    #@ticket = @ticket_answer.ticket
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/0/)
  end
end
