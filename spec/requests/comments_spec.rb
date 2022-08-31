require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  include RequestSpecHelper
  let(:student) { FactoryGirl.create :user }
  # before(:each) do
  #   login(student)
  # end
  describe 'GET /comments' do
    it 'works! (now write some real specs)' do
      get comments_path
      expect(response).to have_http_status(302)
    end
  end
end
