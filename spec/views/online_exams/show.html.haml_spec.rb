require 'rails_helper'

RSpec.describe 'online_exams/show', type: :view do
  login_superadmin
  before(:each) do
    @exam = assign(:online_exam, OnlineExam.create!(
                                   title: 'Title',
                                   instruction: 'MyText'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
