require 'rails_helper'
RSpec.describe 'mcq_stems/show', type: :view do
  login_superadmin
  before(:each) do
    @mcq_stem = assign(:mcq_stem, FactoryGirl.create(McqStem))
  end

  it 'renders attributes in <p>' do
    render
    # expect(rendered).to match(/#{@mcq_stem.title}/)
    # expect(rendered).to match(/#{@mcq_stem.description}/)
    expect(rendered).to have_selector(:link_or_button, 'Edit MCQ Stem')
  end
end
