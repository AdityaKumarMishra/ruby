require 'rails_helper'

RSpec.describe 'online_exams/index', type: :view do
  before(:each) do
    assign(:online_exams, [
             OnlineExam.create!(
               title: 'Title',
               instruction: 'MyText'
             ),
             OnlineExam.create!(
               title: 'Title',
               instruction: 'MyText'
             )
           ])
  end

  xit 'renders a list of exams' do
    allow(view).to receive_messages(:will_paginate => nil)
    render
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
  end
end
