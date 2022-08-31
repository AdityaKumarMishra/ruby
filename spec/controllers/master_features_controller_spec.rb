require 'rails_helper'

RSpec.describe MasterFeaturesController, type: :controller do
    context 'authorized' do
    let(:master_feature) { FactoryGirl.create(:master_feature) }
    let(:master_feature1){ FactoryGirl.create(:master_feature, position: 1) }
    let(:valid_attributes) { FactoryGirl.build(:master_feature).as_json }
    let(:invalid_attributes) { { invalid: -1 } }

    before do
      sign_in FactoryGirl.create(:user, :manager)
    end

    describe 'GET #index' do
      it 'assigns all master features as @master_features' do
        get :index
        expect(assigns(:master_features)).to eq([master_feature1, master_feature])
        expect(response).to be_success
      end
    end

    describe 'GET #show' do
      it 'assigns the requested master_feature as @master_feature' do
        get :show, id: master_feature.to_param
        expect(assigns(:master_feature)).to eq(master_feature)
        expect(response).to be_success
      end
    end

    describe 'GET #new' do
      it 'assigns a new master_feature as @master_feature' do
        get :new
        expect(assigns(:master_feature)).to be_a_new(MasterFeature)
        expect(response).to be_success
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested master_feature as @master_feature' do
        get :edit, id: master_feature.to_param
        expect(assigns(:master_feature)).to eq(master_feature)
        expect(response).to be_success
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new MasterFeature' do
          expect { post :create, master_feature: valid_attributes }.to change(MasterFeature, :count).by(1)
        end

        it 'assigns a newly created master_feature as @master_feature' do
          post :create, master_feature: valid_attributes
          expect(assigns(:master_feature)).to be_a(MasterFeature)
          expect(assigns(:master_feature)).to be_persisted
        end

        it 'redirects to the created master_feature' do
          post :create, master_feature: valid_attributes
          expect(response).to redirect_to(MasterFeature.last)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        it 'assigns the requested master_feature as @master_feature' do
          put :update, id: master_feature.to_param, master_feature: valid_attributes
          expect(assigns(:master_feature)).to eq(master_feature)
          expect(response).to be_redirect
        end
      end
    end

    describe 'DELETE #destroy' do
      before do
        sign_in FactoryGirl.create(:user, :superadmin)
      end

      it 'destroys the requested master_feature' do
        # Create master_feature first by referencing it
        master_feature
        expect { delete :destroy, id: master_feature.id }.to change(MasterFeature, :count).by(-1)
        expect(response).to be_redirect
      end
    end
  end

  context 'unauthorized' do
    let(:master_feature) { FactoryGirl.create(:master_feature) }
    let(:valid_attributes) { FactoryGirl.build(:master_feature).as_json }
    let(:invalid_attributes) { { invalid: -1 } }

    before do
      sign_in FactoryGirl.create(:user, :student)
    end

    describe 'GET #index' do
      it 'does not authorise' do
        get :index
        expect(response).to_not be_success
      end
    end

    describe 'GET #show' do
      it 'does not authorise' do
        get :show, id: master_feature.to_param
        expect(response).to_not be_success
      end
    end

    describe 'GET #new' do
      it 'does not authorise' do
        get :new
        expect(response).to_not be_success
      end
    end

    describe 'GET #edit' do
      it 'does not authorise' do
        get :edit, id: master_feature.to_param
        expect(response).to_not be_success
      end
    end

    describe 'POST #create' do
      it 'does not create a new MasterFeature' do
        expect { post :create, master_feature: valid_attributes }.to change(MasterFeature, :count).by(0)
      end
    end

    describe 'DELETE #destroy' do
      it 'does nothing' do
        # Create master feature first by referencing it
        master_feature

        expect { delete :destroy, id: master_feature.id }.to change(MasterFeature, :count).by(0)
      end
    end
  end
end
