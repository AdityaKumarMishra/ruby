require 'rails_helper'

RSpec.describe 'exercises/show', type: :view do
  before(:each) do
    @exercise = assign(:exercise, FactoryGirl.create(:exercise))
  end

  # it 'renders attributes in <p>' do
  #   render
  #   expect(rendered).to match(//)
  #   expect(rendered).to match(/1/)
  #   expect(rendered).to match(//)
  # end
end
