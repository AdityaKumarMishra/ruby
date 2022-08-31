require 'rails_helper'

RSpec.describe "mcq_answers/show", type: :view do
  before(:each) do
    @mcq_answer = assign(:mcq_answer, McqAnswer.create!(
      :answer => "MyText",
      :correct => false,
      :explanation => "MyText",
      :time_taken => 1,
      :mcq => nil
    ))
  end

  xit "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
  end
end
