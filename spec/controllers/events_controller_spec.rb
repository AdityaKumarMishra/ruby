require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  #Student Authorization
  let!(:tutor) { FactoryGirl.create(:user, :tutor) }
  before { subject.stub(current_user: tutor, authenticate_user!: true) }


  xdescribe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

end
