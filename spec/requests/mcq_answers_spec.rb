require 'rails_helper'

RSpec.xdescribe "McqAnswers", type: :request do
  let!(:mcq){FactoryGirl.create(:mcq)}
  describe "GET /mcq_answers" do
    it "works!" do
      get mcq_mcq_answers_path(mcq)
      expect(response).to have_http_status(200)
    end
  end
end
