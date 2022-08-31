require 'rails_helper'

RSpec.describe 'Enrolments', type: :request do
  describe 'GET /enrolments' do
    let(:user) { FactoryGirl.create :user }
    it 'works! (now write some real specs)' do
      get user_enrolments_path(user_id: user.id)
      expect(response).to have_http_status(302)
    end
  end
end
