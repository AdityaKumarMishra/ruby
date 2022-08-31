require 'rails_helper'

RSpec.describe "mcqs/show", type: :view do
  before(:each) do
    skip 'to be implemented'
    @mcq = assign(:mcq, Mcq.create!( FactoryGirl.attributes_for(:mcq)))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
