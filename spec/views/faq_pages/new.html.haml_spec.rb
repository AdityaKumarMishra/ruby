require 'rails_helper'

RSpec.describe "faq_pages/new", type: :view do
  before(:each) do
    @faq_type = assign(:faq_type, 'gamsat')
    assign(:faq_page, FaqPage.new(
      :faq_topic => nil,
      :content => "MyText"
    ))
  end

  it "renders new faq_page form" do
    render

    assert_select "form[action=?][method=?]", gamsat_admin_faq_pages_path, "post" do

      assert_select "select#faq_page_faq_topic_id[name=?]", "faq_page[faq_topic_id]"

      assert_select "textarea#faq_page_content[name=?]", "faq_page[content]"
    end
  end
end
