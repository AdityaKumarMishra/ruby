require 'rails_helper'

RSpec.describe 'sections/show', type: :view do
  let(:online_exam) { FactoryGirl.create(:online_exam) }
  before(:each) do
    assign(:parent_resource, online_exam)
    @section = assign(:section, Section.create!(
                                  title: 'Title',
                                  duration: 1,
                                  position: 2,
                                  sectionable: online_exam
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
