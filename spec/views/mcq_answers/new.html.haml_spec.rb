require 'rails_helper'

RSpec.describe "mcq_answers/new", type: :view do
  let!(:mcq) {FactoryGirl.create(:mcq)}
  before(:each) do
    skip 'To be corrected'
    assign(:mcq_answer, McqAnswer.new(
      :answer => "MyText",
      :correct => false,
      :explanation => "MyText",
      :mcq => mcq
    ))
  end

  it "renders new mcq_answer form" do
    render

    assert_select "form[action=?][method=?]", mcq_answers_path, "post" do

      assert_select "textarea#mcq_answer_answer[name=?]", "mcq_answer[answer]"

      assert_select "input#mcq_answer_correct[name=?]", "mcq_answer[correct]"

      assert_select "textarea#mcq_answer_explanation[name=?]", "mcq_answer[explanation]"

      assert_select "input#mcq_answer_time_taken[name=?]", "mcq_answer[time_taken]"

      assert_select "input#mcq_answer_mcq_id[name=?]", "mcq_answer[mcq_id]"
    end
  end
end
