require 'rails_helper'

RSpec.describe 'sections/edit', type: :view do
  before(:each) do
    @parent_resource = assign(:parnet_resource, FactoryGirl.create(:online_exam))
    @section = assign(:section, Section.create!(
                                  title: 'MyString',
                                  duration: 1,
                                  position: 1,
                                  sectionable: @parent_resource
    ))
  end

  xit 'renders the edit section form' do
    render

    assert_select 'form[action=?][method=?]', polymorphic_path([@parent_resource, @section]), 'post' do
      assert_select 'input#section_title[name=?]', 'section[title]'

      assert_select 'input#section_duration[name=?]', 'section[duration]'

      assert_select 'input#section_position[name=?]', 'section[position]'
    end
  end
end
