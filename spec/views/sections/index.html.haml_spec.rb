require 'rails_helper'

RSpec.describe 'sections/index', type: :view do
  login_superadmin
  let(:online_exam) { FactoryGirl.create :online_exam }
  before(:each) do
    assign(:parent_resource, online_exam)
    assign(:sections, [
             Section.create!(
               title: 'Title',
               duration: 1,
               position: 45,
               sectionable: online_exam
             ),
             Section.create!(
               title: 'Title',
               duration: 1,
               position: 2,
               sectionable: online_exam
             )
           ])
  end

  it 'renders a list of sections' do
    render
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: 1.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 1
    assert_select 'tr>td', text: 45.to_s, count: 1
  end
end
