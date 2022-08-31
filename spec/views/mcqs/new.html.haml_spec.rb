require 'rails_helper'

RSpec.xdescribe "mcqs/new", type: :view do
  before(:each) do
    assign(:mcq, Mcq.new(
      :question => "MyText",
      :difficulty => 1.5,
      :examinable => false,
      :publish => false
    ))
  end

  it "renders new mcq form" do
    render

    assert_select "form[action=?][method=?]", mcqs_path, "post" do

      assert_select "textarea#mcq_question[name=?]", "mcq[question]"

      assert_select "input#mcq_difficulty[name=?]", "mcq[difficulty]"

      assert_select "input#mcq_examinable[name=?]", "mcq[examinable]"
      
    end
  end
end
