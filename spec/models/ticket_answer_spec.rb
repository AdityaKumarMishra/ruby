require 'rails_helper'

RSpec.describe TicketAnswer, type: :model do
  let(:answer) { FactoryGirl.create :ticket_answer }
  it { should have_many(:comments).dependent(:destroy)}
  it 'validates ticket' do
    expect(answer).to validate_presence_of(:ticket)
  end

  it 'validates content presence' do
    expect(answer).to validate_presence_of(:content)
  end

  it 'validates user presence' do
    expect(answer).to validate_presence_of(:user)
  end
end
