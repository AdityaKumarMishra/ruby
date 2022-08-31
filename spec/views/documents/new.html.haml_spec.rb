require 'rails_helper'

RSpec.describe "documents/new", type: :view do
  before(:each) do
    assign(:document, Document.new(
      :accessible => false,
      :allow_dummy => false,
      :only_dummy => false,
      :attachment_file_name => 'test.pdf',
      :attachment_content_type => 'application/pdf',
      :attachment_file_size => 1024,
    ))
  end

  it "renders new document form" do
    render

    assert_select "form[action=?][method=?]", documents_path, "post" do
      assert_select "input#document_for_timetable[name=?]", "document[for_timetable]"
      assert_select "input#document_for_paid[name=?]", "document[for_paid]"
      assert_select "input#document_for_trial[name=?]", "document[for_trial]"
    end
  end
end
