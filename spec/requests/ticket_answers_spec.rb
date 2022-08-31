require 'rails_helper'

RSpec.describe 'TicketAnswers', type: :request do
  include RequestSpecHelper
  let(:tutor) { FactoryGirl.create :user, :tutor }
  let(:ticket_answer) { FactoryGirl.create :ticket_answer }
  before(:each) do
    login(tutor)
  end
  describe 'GET /ticket_answers' do
    it 'works! (now write some real specs)' do
      get ticket_ticket_answers_path(ticket_answer.ticket,ticket_answer)
      expect(response).to have_http_status(200)
    end
  end
end
