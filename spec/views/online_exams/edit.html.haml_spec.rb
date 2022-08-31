require 'rails_helper'

RSpec.describe 'online_exams/edit', type: :view do
  before(:each) do
    @online_exam = assign(:online_exam, OnlineExam.create!(
                            title: 'MyString',
                            instruction: 'MyText'
    ))
  end

  xit 'renders the edit online_exam form' do
    render

    assert_select 'form[action=?][method=?]', online_exam_path(@online_exam), 'post' do
      assert_select 'input#online_exam_title[name=?]', 'online_exam[title]'

      assert_select 'textarea#online_exam_instruction[name=?]', 'online_exam[instruction]'
    end
  end
end
