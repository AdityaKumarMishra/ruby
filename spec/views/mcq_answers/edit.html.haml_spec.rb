require 'rails_helper'

RSpec.describe "mcq_answers/edit", type: :view do
  let!(:mcq) {FactoryGirl.create(:mcq)}
  before(:each) do
    skip 'To be corrected'

    @mcq_answer = assign(:mcq_answer, McqAnswer.create!(
      :answer => "MyText",
      :correct => false,
      :mcq => mcq
    ))
  end

  it "renders the edit mcq_answer form" do
    render

    assert_select "form[action=?][method=?]", mcq_mcq_answer_path(mcq,@mcq_answer), "post" do

      assert_select "textarea#mcq_answer_answer[name=?]", "mcq_answer[answer]"

      assert_select "input#mcq_answer_correct[name=?]", "mcq_answer[correct]"

      assert_select "input#mcq_answer_mcq_id[name=?]", "mcq_answer[mcq_id]"
    end
  end
end
