require 'rails_helper'
RSpec.describe UserEnrolmentsController, type: :controller do
  login_superadmin

  let!(:enrolment) { FactoryGirl.create :enrolment, state: 1}
  let!(:order) {FactoryGirl.create(:order, user_id: subject.current_user.id, status: 3)}
  let!(:purchase_item) { FactoryGirl.create(:purchase_item, purchasable: enrolment, order: order) }
  let(:valid_attributes) do
    FactoryGirl.attributes_for :enrolment, course_id: course.id
  end

  describe 'GET #index' do
    it 'assigns all enrolments as @enrolments' do
      get :index, user_id: subject.current_user.id
      expect(assigns(:enrolments)).to eq([enrolment])
    end
  end
end
