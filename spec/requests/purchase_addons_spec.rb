require 'rails_helper'

RSpec.describe "PurchaseAddons", type: :request do
  describe "GET /purchase_addons" do
    include RequestSpecHelper
    let(:superadmin) { FactoryGirl.create(:user, :superadmin)}
    before(:each) do
      login(superadmin)
    end


    it "works! (now write some real specs)" do

      get purchase_addons_path
      expect(response).to have_http_status(200)
    end
  end
end
