require 'rails_helper'

RSpec.describe 'exercises/index', type: :view do
  let(:exercise1) { FactoryGirl.create :exercise }
  let(:exercise2) do
    FactoryGirl.create :exercise, name: exercise1.name,
                                  difficulty: exercise1.difficulty, amount: exercise1.amount,
                                  user: exercise1.user
  end
  before(:each) do
    assign(:exercises, [exercise1, exercise2])
  end
  let(:filterrific) do initialize_filterrific( McqStem.all, params[:filterrific]) end

  xit 'renders a list of exercises' do
    render
    assert_select 'tr>td', text: exercise1.name.to_s, count: 2
    assert_select 'tr>td', text: exercise1.difficulty.to_s, count: 2
  end
end
