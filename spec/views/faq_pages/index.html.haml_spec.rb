require 'rails_helper'

RSpec.describe "faq_pages/index", type: :view do
  before(:each) do
    assign(:array_hash_of_topics, [
      { 'gamsat' => [FactoryGirl.create(:faq_page)] },
      { 'umat' => [FactoryGirl.create(:faq_page)] },
      { 'vce' => [FactoryGirl.create(:faq_page)] },
      { 'hsc' => [FactoryGirl.create(:faq_page)] }
    ])
    assign(:product_lines, ['gamsat', 'umat', 'hsc', 'vce'])
  end

  xit "renders a list of faq_pages" do
    render
    expect(rendered).to have_content FaqTopic.first.title
  end
end
