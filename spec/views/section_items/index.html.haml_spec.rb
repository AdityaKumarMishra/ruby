require 'rails_helper'

RSpec.describe 'section_items/index', type: :view do
  let(:mcq_stem1) { FactoryGirl.create :mcq_stem, :examinable, title: 'Hello' }
  let(:mcq) { FactoryGirl.create :mcq, question: "It's me"}
  before(:each) do
    @parent_resource = assign(:online_exam, FactoryGirl.create(:online_exam))
    @section = assign(:section, FactoryGirl.create(:section, sectionable: @parent_resource))
    assign(:section_items, [FactoryGirl.create(:section_item, mcq_stem: mcq_stem1, mcq: mcq),
                            FactoryGirl.create(:section_item, mcq_stem: mcq_stem1, mcq: mcq)])
  end

  it 'renders a list of section_items' do
    render
    assert_select 'tr>td', text: mcq_stem1.title.to_s, count: 1
    assert_select 'tr>td', text: "Hello", count: 1
  end
end
