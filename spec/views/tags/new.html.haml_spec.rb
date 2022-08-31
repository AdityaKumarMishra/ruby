require 'rails_helper'

RSpec.describe 'tags/new', type: :view do
  before(:each) do
    assign(:tag, Tag.new(
                   name: 'MyString',
                   description: 'MyText',
                   tagging_count: 1,
                   parent_id: 1
    ))
  end

  it 'renders new tag form' do
    render

    assert_select 'form[action=?][method=?]', tags_path, 'post' do
      assert_select 'input#tag_name[name=?]', 'tag[name]'

      assert_select 'textarea#tag_description[name=?]', 'tag[description]'

      assert_select 'select#tag_parent_id[name=?]', 'tag[parent_id]'
    end
  end
end
