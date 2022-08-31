require 'rails_helper'

RSpec.describe "TransferTransactions", type: :request do
  describe "GET /transfer_transactions" do
    include RequestSpecHelper
    let(:superadmin) { FactoryGirl.create(:user, :superadmin) }
    before(:each) do
      login(superadmin)
    end

    it "works! (now write some real specs)" do
      get transfer_transactions_path
      expect(response).to have_http_status(200)
    end
  end
end
