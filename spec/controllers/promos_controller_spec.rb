require 'rails_helper'

RSpec.describe PromosController, type: :controller do
  before { sign_in user }

  context 'as manager' do
    let(:user) { FactoryGirl.create(:user, :manager) }
    let(:promo) { FactoryGirl.create(:promo) }
    let(:attrs) do
      { token: 'newtoken', stackable: true, amount: "0.1", used_times: 2 }
    end
    let(:invalid_attrs) do
      { token: 'newtoken', stackable: true, amount: "0.1", used_times: 0 }
    end

    describe "GET #index" do
      it 'shows all promos' do
        get :index
        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it 'shows a promo' do
        get :show, id: promo.id
        expect(response).to be_success
      end
    end

    describe "GET #edit" do
      it 'edits a promo' do
        get :edit, id: promo.id
        expect(response).to be_success
      end
    end

    describe "GET #new" do
      it 'new promo' do
        get :new
        expect(response).to be_success
      end
    end

    describe "PATCH #update" do
      it 'updates promos' do
        patch :update, id: promo.id, promo: attrs
        expect(response).to be_redirect
        promo.reload

        expect(promo.token).to eq attrs[:token].upcase
        expect(promo.stackable).to eq attrs[:stackable]
        expect(promo.amount).to eq BigDecimal.new(attrs[:amount])
      end
    end

    describe "POST #create" do
      it 'create a promo with valid attrs' do
        expect {
          post :create, promo: attrs
        }.to change(Promo, :count).by(1)
        expect(response).to be_redirect
      end

      it 'create a promo with valid invalid attrs' do
        expect {
          post :create, promo: invalid_attrs
        }.to change(Promo, :count).by(0)
      end
    end

    describe "DELETE #destroy" do
      it 'destroys a promo' do
        promo # Create a promo

        expect {
          delete :destroy, id: promo.id
        }.to change(Promo, :count).by(-1)

        expect(response).to be_redirect
      end
    end
  end

  context 'as student' do
    let(:user) { FactoryGirl.create(:user, :student) }
    let(:promo) { FactoryGirl.create(:promo) }

    it 'is not authorized' do
      get :index
      expect(response).not_to be_success

      get :show, id: promo.id
      expect(response).not_to be_success

      get :new
      expect(response).not_to be_success

      get :edit, id: promo.id
      expect(response).not_to be_success

      post :create
      expect(response).not_to be_success

      patch :update, id: promo.id
      expect(response).not_to be_success

      delete :destroy, id: promo.id
      expect(response).not_to be_success
    end
  end
end
