require 'rails_helper'

RSpec.describe TagRelationsController, type: :controller do
  login_superadmin
  let!(:tag) {FactoryGirl.create :tag}
  let!(:mcq) {FactoryGirl.create :mcq, tag: tag}
  let(:valid_session) {}
  describe 'POST #create' do
    context 'with valid params' do
      it 'should associate tag with mcq' do
        post :create, {mcq:{tag_id: tag.to_param,id: mcq.id}}, valid_session
        mcq.reload
        expect(mcq.tag).to eq(tag)
      end
    end
  end
  describe 'DELETE #destroy' do
    context 'with valid params' do
      it 'should remove the associated tag' do
        delete :destroy, {mcq:{id: mcq.id, tag_id: tag.id}, id: mcq.id}, valid_session
        expect(mcq.reload.tag).to be_nil
      end
    end
  end
end
