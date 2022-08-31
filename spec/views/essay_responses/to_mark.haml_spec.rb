require 'rails_helper'

RSpec.describe "essay_responses/to_mark", type: :view do
  before(:each) do
    @essay_response = FactoryGirl.create(:essay_response)
  end
  xit "renders a list of Essay responses to be marked" do
    xhr :get, :update, :format => "js"
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Time Submitted".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end