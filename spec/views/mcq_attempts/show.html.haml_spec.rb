require 'rails_helper'

RSpec.describe 'mcq_attempts/show', type: :view do
  before do
    @mcq_attempt = nil
    @exercise = assign(:exercise, FactoryGirl.create(:exercise))
  end

  it 'render show without error' do
    expect { render }.not_to raise_error
  end
end
