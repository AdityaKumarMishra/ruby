require 'rails_helper'

RSpec.describe "documents/index", type: :view do
  before(:each) do
    assign(:documents, [
      Document.create!(
        :accessible => true,
        :allow_dummy => true,
        :only_dummy => false,
        :attachment_file_name => 'test.pdf',
        :attachment_content_type => 'application/pdf',
        :attachment_file_size => 1024,
      ),
      Document.create!(
        :accessible => true,
        :allow_dummy => true,
        :only_dummy => false,
        :attachment_file_name => 'test.pdf',
        :attachment_content_type => 'application/pdf',
        :attachment_file_size => 1024,
      )
    ])
  end

  xit "renders a list of documents" do
    render
    assert_select "tr>td", :text => true.to_s, :count => 2
    assert_select "tr>td", :text => true.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
