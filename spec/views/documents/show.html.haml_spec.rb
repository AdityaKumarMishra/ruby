require 'rails_helper'

RSpec.describe "documents/show", type: :view do
  before(:each) do
    @document = assign(:document, Document.create!(
      :accessible => false,
      :allow_dummy => false,
      :only_dummy => false,
      :attachment_file_name => 'test.pdf',
      :attachment_content_type => 'application/pdf',
      :attachment_file_size => 1024,
    ))
  end

  xit "renders attributes in <p>" do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
