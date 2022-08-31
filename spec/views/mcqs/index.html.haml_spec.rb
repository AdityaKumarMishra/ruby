require 'rails_helper'

RSpec.describe 'mcq_stems/:id/mcqs/index', type: :view do
  before(:each) do
    mcq1 = FactoryGirl.create :mcq
    mcq2 = FactoryGirl.create :mcq, mcq_stem: mcq1.mcq_stem
    assign(:mcqs, [mcq1, mcq2])
    controller.request.path_parameters[:mcq_stem_id] = mcq1.mcq_stem.id
  end

  it 'renders a list of mcqs' do
    pending ('missing template')
    allow(view).to receive_messages(will_paginate: nil)
    render
    expect(rendered).to have_content(mcq1.title)
    expect(rendered).to have_content(mcq2.title)
    expect(rendered).to have_selector("input[type=button][value='Reassign']")
  end
end
