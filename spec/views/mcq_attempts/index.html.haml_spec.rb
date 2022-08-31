require 'rails_helper'

RSpec.describe 'mcq_attempts/index', type: :view do
  before(:each) do
    assign(:mcq_attempts, [FactoryGirl.create(:mcq_attempt)])
  end

  it 'renders a list of mcq_attempts' do
    pending('needs tab to be implement')
    render
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
  end
end
