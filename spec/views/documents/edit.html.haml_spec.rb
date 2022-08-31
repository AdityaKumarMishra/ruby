require 'rails_helper'

RSpec.describe "documents/edit", type: :view do
  before(:each) do
    @document = assign(:document, Document.create!(
      :accessible => true,
      :for_timetable => true,
      :product_line_id => 1,
      :allow_dummy => false,
      :only_dummy => false,
      :attachment_file_name => 'test.pdf',
      :attachment_content_type => 'application/pdf',
      :attachment_file_size => 1024,
    ))
  end

  it "renders the edit document form" do
    render

    assert_select "form[action=?][method=?]", document_path(@document), "post" do
      assert_select "input#document_for_timetable[name=?]", "document[for_timetable]"
      assert_select "input#document_for_paid[name=?]", "document[for_paid]"
      assert_select "input#document_for_trial[name=?]", "document[for_trial]"
    end
  end
end
