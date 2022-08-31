require 'rails_helper'

RSpec.describe LiveExamsController, type: :controller do

  let!(:user) {
    FactoryGirl.create(:user, email: "hr@gradready.com.au", role: "admin")
  }
  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:student) { FactoryGirl.create(:user, :student) }
  let!(:course) { FactoryGirl.create(:course, product_version_id: productVer.id) }
  let!(:enrolment) { FactoryGirl.create(:enrolment, course_id: course.id) }
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }

  let!(:master_feature1) { FactoryGirl.create(:master_feature, name: 'GamsatLiveExamFeature', title: 'Exams') }
  let!(:live_exam) { FactoryGirl.create(:live_exam, course_id: course.id, user_id: student.id, section_type: 'GamsatReady')}

  let!(:pvfp1) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature1,
                       product_version: productVer, is_default: true
                      )
  end

  let!(:feature_log1) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp1,
                                     acquired: Time.zone.now, enrolment: enrolment
                      )
  end
  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
  let!(:valid_attributes) { FactoryGirl.build(:live_exam, course_id: course.id, section_type: 'GamsatReady').as_json }

  before do
    sign_in student
  end

  describe 'GET #index' do
    it 'assigns current course live exam as @live_exam' do
      student.update_attribute(:active_course_id, course.id)
      get :index
      expect(assigns(:live_exam)).to eq(live_exam)
      expect(response).to be_success
    end
  end

  describe 'GET #create' do
    it 'it should save the student score' do
      student.update_attribute(:active_course_id, course.id)
      expect { post :create, live_exam: valid_attributes }.to change(LiveExam, :count).by(0)
    end
  end

  describe 'DELETE #destroy' do
    context "while login student" do
      before { sign_in student }
      it 'destroys the requested live exam' do
        live_exam
        student.update_attribute(:active_course_id, course.id)
        expect { delete :destroy, id: live_exam.id }.to change(LiveExam, :count).by(0)
        expect(response).to be_redirect
      end
    end

    context "while login admin" do
      before { sign_in FactoryGirl.create(:user, :admin ) }
      it 'destroys the requested live exam' do
        live_exam
        @request.env['HTTP_REFERER'] = 'http://localhost:3000'
        expect { delete :destroy, id: live_exam.id }.to change(LiveExam, :count).by(-1)
        expect(response).to be_redirect
      end
    end
  end
end
