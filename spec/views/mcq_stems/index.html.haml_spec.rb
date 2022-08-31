require 'rails_helper'

RSpec.describe "mcq_stems/index", type: :view do
  before(:each) do
    assign(:mcq_stems, [
      McqStem.create!(
        :title => "Title",
        :description => "MyText"
      ),
      McqStem.create!(
        :title => "Title",
        :description => "MyText"
      )
    ])
  end

  xit "renders a list of mcq_stems" do
    xhr :put, :update, :format => "js"
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
