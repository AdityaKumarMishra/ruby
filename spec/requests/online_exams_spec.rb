require 'rails_helper'

RSpec.describe 'OnlineExams', type: :request do
  include RequestSpecHelper
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  before(:each) do
    login(superadmin)
  end
  describe 'GET /online_exams' do
    it 'works! (now write some real specs)' do
      get online_exams_path
      expect(response).to have_http_status(200)
    end
  end
end
