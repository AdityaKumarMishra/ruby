require 'rails_helper'

RSpec.describe 'section_items/edit', type: :view do
  before(:each) do
    @parent_resource = assign(:parent_resource, FactoryGirl.create(:online_exam))
    @section = assign(:section, FactoryGirl.create(:section, sectionable: @parent_resource))
    @section_item = assign(:section_item, FactoryGirl.create(:section_item, section: @section))
    allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(FactoryGirl.create(:user, :superadmin), McqStem))
  end

  it 'renders the edit section_item form' do
    render
    assert_select 'form[action=?][method=?]', polymorphic_path([@parent_resource, @section, @section_item]), 'post' do
      assert_select 'select#section_item_mcq_id[name=?]', 'section_item[mcq_id]'
    end
  end
end
