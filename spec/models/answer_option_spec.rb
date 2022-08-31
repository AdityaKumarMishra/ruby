require 'rails_helper'

RSpec.describe AnswerOption, type: :model do
  subject(:answer_option) { FactoryGirl.build(:answer_option) }

  it 'has valid :dropdown_answer factory' do
    expect(answer_option).to be_valid
  end

  it { should validate_presence_of(:content).with_message('Please provide an answer') }
  it { expect(answer_option).to belong_to :application_question }
end
