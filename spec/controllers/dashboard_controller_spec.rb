require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  # Student Authorization
  let!(:student) { FactoryGirl.create(:user, :student) }
  let!(:tutor) { FactoryGirl.create(:user, :tutor) }
  before { subject.stub(current_user: tutor, authenticate_user!: true) }

  xdescribe 'GET #student' do
    it 'returns http success' do
      get :student
      expect(response).to have_http_status(:success)
    end
  end

  describe '#staff_answered_questions' do
    it 'assigns all tutors as @tutors' do
      get :staff_answered_questions, {}
      expect(assigns(:tutors)).to eq([tutor])
    end
  end

  describe '#tutor_appointments' do
    it 'display details of a tutor' do
      get :tutor_appointments, {tutor_id: tutor}
      expect(assigns(:tutor)).to eq(tutor)
    end
  end

  describe '#dashboard' do
    login_student
    it 'assigns product lines announcements' do
      productVer = FactoryGirl.create(:product_version, type: 'GamsatReady')
      course = FactoryGirl.create(:course, product_version_id: productVer.id)
      order = FactoryGirl.create(:order, status: :paid, user: subject.current_user)
      enrolment = FactoryGirl.create(:enrolment)
      paid_purchase_item = FactoryGirl.create(:purchase_item, user: subject.current_user, order: order, purchasable: enrolment)
      announcement = FactoryGirl.create(:announcement, name: 'GamsatReady-dashboard',
                                                       category: 'Dashboardpage', description: 'dashboard announcements'
                                       )
      subject.current_user.update_attribute(:active_course_id, course.id)
      get :home, {}
      expect(assigns(:announcement)).to eq(announcement)
    end
  end
end
