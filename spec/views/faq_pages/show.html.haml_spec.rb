require 'rails_helper'

RSpec.describe "faq_pages/show", type: :view do
  before(:each) do
    @faq_type = assign(:faq_type, 'gamsat')
    @faq_page = assign(:faq_page, FactoryGirl.create(
      :faq_page,
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
  end
end
