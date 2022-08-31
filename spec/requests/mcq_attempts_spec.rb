require 'rails_helper'

RSpec.describe 'McqAttempts', type: :request do
  # authorzation
  describe 'GET /exercises/:id/mcq_attempts' do
    xit 'works! (now write some real specs)' do
      get exercise_mcq_attempts_path(exercise)
      expect(response).to have_http_status(200)
    end
  end
end
