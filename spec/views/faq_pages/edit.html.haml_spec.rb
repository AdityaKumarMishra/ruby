require 'rails_helper'

RSpec.describe "faq_pages/edit", type: :view do
  before(:each) do
    @faq_type = assign(:faq_type, 'gamsat')
    @faq_page = assign(:faq_page, FactoryGirl.create(
      :faq_page,
      :content => "MyText"
    ))
  end

  it "renders the edit faq_page form" do
    render

    assert_select "form[action=?][method=?]", gamsat_admin_faq_page_path(@faq_page), "post" do

      assert_select "select#faq_page_faq_topic_id[name=?]", "faq_page[faq_topic_id]"

      assert_select "textarea#faq_page_content[name=?]", "faq_page[content]"
    end
  end
end
