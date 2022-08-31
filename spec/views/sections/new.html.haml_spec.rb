require 'rails_helper'

RSpec.describe 'sections/new', type: :view do
  let(:online_exam) { FactoryGirl.create(:online_exam) }
  before(:each) do
    @parent_resource = assign(:parent_resource, online_exam)
    assign(:section, Section.new(
                       title: 'MyString',
                       duration: 1,
                       position: 1,
                       sectionable: online_exam
    ))
  end

  it 'renders new section form' do
    render

    assert_select 'form[action=?][method=?]', polymorphic_path([@parent_resource, Section]), 'post' do
      assert_select 'input#section_title[name=?]', 'section[title]'

      assert_select 'input#section_duration[name=?]', 'section[duration]'

      assert_select 'input#section_position[name=?]', 'section[position]'
    end
  end
end
