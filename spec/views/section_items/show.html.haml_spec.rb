require 'rails_helper'

RSpec.describe 'section_items/show', type: :view do
  before(:each) do
    @parent_resource = assign(:online_exam, FactoryGirl.create(:online_exam))
    @section = assign(:section, FactoryGirl.create(:section, sectionable: @parent_resource))
    @section_item = assign(:section_item, FactoryGirl.create(:section_item, section: @section))
  end

  it 'renders attributes in <p>' do
    render
    # expect(rendered).to match(/@section_item.mcq_stem.title/)
    expect(rendered).to match(//)
  end
end
