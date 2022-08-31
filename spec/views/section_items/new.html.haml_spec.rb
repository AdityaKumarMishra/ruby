require 'rails_helper'

RSpec.describe 'section_items/new', type: :view do
  let(:online_exam) { FactoryGirl.create :online_exam }
  let(:section) { FactoryGirl.create :section, sectionable: online_exam }
  before(:each) do
    @parent_resource = assign(:parent_resource, online_exam)
    @section = assign(:section, section)
    assign(:section_item, SectionItem.new(mcq_stem: nil, mcq: nil))
    allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(FactoryGirl.create(:user, :superadmin), McqStem))
  end

  it 'renders new section_item form' do
    render

    assert_select 'div', 'All child MCQs will be added in the exam/test.'
    assert_select 'form[action=?][method=?]', online_exam_section_section_items_path(@parent_resource, @section), 'post' do
      # assert_select 'div>input#mcq_stem_ids_[name=?]', 'mcq_stem_ids[]'

      # assert_select 'select#section_item_mcq_id[name=?]', 'section_item[mcq_id]'
    end
  end
end
