require 'rails_helper'

RSpec.describe ContactController, type: :controller do
  login_superadmin
  let(:valid_attributes) {
    FactoryGirl.attributes_for(:contact_form)
  }

  let(:invalid_attributes) {
    FactoryGirl.attributes_for(:contact_form,email:'')
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  xdescribe "POST #create_inquire" do
    context "with valid params" do
      it "add new inquire" do
        expect {
          post :create_inquire, {:contact_form => valid_attributes}, valid_session
        }.to change(ContactForm, :count).by(1)
      end
    end
  end
end
