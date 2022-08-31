  require 'rails_helper'

RSpec.describe "subjects/index", type: :view do
  before do
    10.times do
      FactoryGirl.build(:subject)
    end
  end

  it "renders a list of subjects" do
    render
  end
end
