require 'rails_helper'

RSpec.describe "job_application_forms/index", type: :view do
  before(:each) do
    assign(:job_application_forms, [
      JobApplicationForm.create!(
        title: "Title",
        description: "MyText",
        open: true
      ),
      JobApplicationForm.create!(
        title: "Title",
        description: "MyText",
        open: true
      )
    ])
  end

  xit "renders a list of job_application_forms" do
    allow(view).to receive_messages(:will_paginate => nil)
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
