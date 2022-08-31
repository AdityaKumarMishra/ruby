require 'rails_helper'

RSpec.describe UserEmailsController, type: :controller do
  let(:valid_session) { {} }

  describe 'GET #download' do
    login_superadmin
    it 'it should download xls file' do
      get :download, { format: 'xls' }, valid_session
      expect(controller.headers['Content-Type']).to eq('application/xls; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end
end
