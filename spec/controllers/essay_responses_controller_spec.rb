require 'rails_helper'

RSpec.describe EssayResponsesController, type: :controller do
  login_admin
  let!(:essay_response) { FactoryGirl.create(:essay_response, user: subject.current_user) }
  let!(:student_order) {FactoryGirl.create(:order, user: subject.current_user)}
  let!(:student_enrolment) {FactoryGirl.create(:enrolment) }
  let!(:student_purchase_item) {FactoryGirl.create(:purchase_item, order: student_order, purchasable: student_enrolment, user: subject.current_user)}

  describe 'POST #submit' do
    it 'it should submit the essay response' do
      post :submit, essay_response_id: essay_response.id
      expect(response).to redirect_to essay_responses_path
    end
  end

  describe 'GET #show' do
    it 'assigns the requested ticket as @ticket' do
      get :show, id: essay_response.to_param
      expect(assigns(:essay_response)).to eq(essay_response)
    end
  end

  describe 'GET #tutor_essays' do
    it 'gets the righ essays' do
      get :tutor_essays
      expect(response.status).to eq (200)
      expect(assigns[:calendar_data]).to eq({essay_response.expiry_date.strftime('%Y-%m-%d') => {subject.current_user.full_name => 1}})
    end
  end

end
