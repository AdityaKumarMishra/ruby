require 'rails_helper'

RSpec.describe "subjects/edit", type: :view do
  before(:each) do
    @subject = FactoryGirl.build(:subject)
  end

  it "renders the edit subject form" do
    render
  end
end
