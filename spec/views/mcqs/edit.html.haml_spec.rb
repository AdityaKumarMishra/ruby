require 'rails_helper'

RSpec.xdescribe "mcqs/edit", type: :view do
  before(:each) do
    @mcq = assign(:mcq, Mcq.create!(
      :question => "MyText",
      :difficulty => 1.5,
      :explanation => 'sample text',
      :examinable => false,
      :publish => false
    ))
  end

  it "renders the edit mcq form" do
    render

    assert_select "form[action=?][method=?]", mcq_path(@mcq), "post" do

      assert_select "textarea#mcq_question[name=?]", "mcq[question]"

      assert_select "input#mcq_difficulty[name=?]", "mcq[difficulty]"

      assert_select "input#mcq_examinable[name=?]", "mcq[examinable]"

    end
  end
end
