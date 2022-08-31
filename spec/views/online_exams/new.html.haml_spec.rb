require 'rails_helper'

RSpec.describe 'online_exams/new', type: :view do
  before(:each) do
    assign(:online_exam, OnlineExam.new(title: 'MyString',
                                        instruction: 'MyText'))
  end

  xit 'renders new online_exam form' do
    render

    assert_select 'form[action=?][method=?]', online_exams_path, 'post' do
      assert_select 'input#online_exam_title[name=?]', 'online_exam[title]'

      assert_select 'textarea#online_exam_instruction[name=?]', 'online_exam[instruction]'
    end
  end
end
