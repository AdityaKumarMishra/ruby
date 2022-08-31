=begin
require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe VodsController, type: :controller do
  login_superadmin
  # This should return the minimal set of attributes required to create a valid
  # Vod. As you add validations to Vod, be sure to
  # adjust the attributes here as well.
  let!(:subject) { FactoryGirl.create(:subject) }
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:vod, subject_id: subject.id)
  end

  let(:invalid_attributes) do
    FactoryGirl.attributes_for(:vod, subject_id: subject.id, title: nil)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VodsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    describe 'subject_id not present' do
      it 'assigns all vods as @vods' do
        vod = Vod.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:vods)).to eq([vod])
      end
    end
    describe 'subject_id present' do
      let!(:subject) { FactoryGirl.create(:subject) }
      let!(:vod_without_subject) { FactoryGirl.create(:vod) }

      describe 'video_category_id present' do
        let!(:video_category) { FactoryGirl.create(:video_category, subject_id: subject.id) }
        let(:vod_without_subject) { FactoryGirl.create(:vod) }

        it 'assign video_category.vods as @vods' do
          vod = FactoryGirl.create(:vod, subject_id: subject.id, video_category_id: video_category.id)
          get :index, { video_category_id: video_category.id }, valid_session
          expect(assigns(:vods)).to eq([vod])
        end
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested vod as @vod' do
      vod = Vod.create! valid_attributes
      get :show, { id: vod.to_param }, valid_session
      expect(assigns(:vod)).to eq(vod)
    end
    it 'increments the viewcount' do
      vod = Vod.create! valid_attributes
      expect do
        get :show, { id: vod.to_param }, valid_session
        vod.reload
      end.to change { vod.viewcount }.by(1)
    end
  end

  describe 'GET #new' do
    it 'assigns a new vod as @vod' do
      get :new, {}, valid_session
      expect(assigns(:vod)).to be_a_new(Vod)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested vod as @vod' do
      vod = Vod.create! valid_attributes
      get :edit, { id: vod.to_param }, valid_session
      expect(assigns(:vod)).to eq(vod)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Vod' do
        expect do
          post :create, { vod: valid_attributes }, valid_session
        end.to change(Vod, :count).by(1)
      end

      it 'assigns a newly created vod as @vod' do
        post :create, { vod: valid_attributes }, valid_session
        expect(assigns(:vod)).to be_a(Vod)
        expect(assigns(:vod)).to be_persisted
      end

      it 'redirects to the created vod' do
        post :create, { vod: valid_attributes }, valid_session
        expect(response).to redirect_to(Vod.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved vod as @vod' do
        post :create, { vod: invalid_attributes }, valid_session
        expect(assigns(:vod)).to be_a_new(Vod)
      end

      it "re-renders the 'new' template" do
        post :create, { vod: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        FactoryGirl.attributes_for(:vod, title: 'Updated title')
      end

      it 'updates the requested vod' do
        vod = Vod.create! valid_attributes
        put :update, { id: vod.to_param, vod: new_attributes }, valid_session
        vod.reload
        expect(vod.title).to eq('Updated title')
      end

      it 'assigns the requested vod as @vod' do
        vod = Vod.create! valid_attributes
        put :update, { id: vod.to_param, vod: valid_attributes }, valid_session
        expect(assigns(:vod)).to eq(vod)
      end

      it 'redirects to the vod' do
        vod = Vod.create! valid_attributes
        put :update, { id: vod.to_param, vod: valid_attributes }, valid_session
        expect(response).to redirect_to(vod)
      end
    end

    context 'with invalid params' do
      it 'assigns the vod as @vod' do
        vod = Vod.create! valid_attributes
        put :update, { id: vod.to_param, vod: invalid_attributes }, valid_session
        expect(assigns(:vod)).to eq(vod)
      end

      it "re-renders the 'edit' template" do
        vod = Vod.create! valid_attributes
        put :update, { id: vod.to_param, vod: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested vod' do
      vod = Vod.create! valid_attributes
      expect do
        delete :destroy, { id: vod.to_param }, valid_session
      end.to change(Vod, :count).by(-1)
    end

    it 'redirects to the vods list' do
      vod = Vod.create! valid_attributes
      delete :destroy, { id: vod.to_param }, valid_session
      expect(response).to redirect_to(vods_url)
    end
  end
end
=end