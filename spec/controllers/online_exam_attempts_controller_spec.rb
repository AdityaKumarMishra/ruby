require 'rails_helper'

RSpec.describe OnlineExamAttemptsController, type: :controller do
  login_student
  let(:online_exam) { FactoryGirl.create(:online_exam, :published_with_sections) }
  let(:valid_attributes) do
    { user_id: subject.current_user.id, assessable_id: online_exam.to_param, assessable_type: "OnlineExam"}
  end

  let(:invalid_attributes) do
    { assessable_id: nil }
  end

  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:master_feature1) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature') }

  let!(:paidorder) { FactoryGirl.create(:order, status: :paid, user: subject.current_user) }
  let!(:pvfp1) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature1,
                       product_version: productVer, is_default: true
                      )
  end

  let!(:course1) { FactoryGirl.create(:course, product_version: productVer) }

  let!(:enrolment) { FactoryGirl.create(:enrolment, course: course1) }

  # current user feature logs
  let!(:feature_log1) do
    FactoryGirl.create(:feature_log,
                       product_version_feature_price:
                      pvfp1, acquired: DateTime.now, enrolment: enrolment
                      )
  end

  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: subject.current_user, order: paidorder, purchasable: enrolment) }
  let!(:questionnaire) { FactoryGirl.create(:questionnaire, user: subject.current_user)}

  describe 'GET #index' do
    xit 'assigns all online_exam_attempts as @online_exam_attempts' do
      productVer = FactoryGirl.create(:product_version, type: 'GamsatReady')
      course = FactoryGirl.create(:course, product_version_id: productVer.id)
      order = FactoryGirl.create(:order, status: :paid, user: subject.current_user)
      enrolment = FactoryGirl.create(:enrolment)
      paid_purchase_item = FactoryGirl.create(:purchase_item, user: subject.current_user, order: order, purchasable: enrolment)
      announcement = FactoryGirl.create(:announcement, name: 'GamsatReady-dashboard',
                                                       category: 'Dashboardpage', description: 'dashboard announcements'
                                       )
      subject.current_user.active_course = course
      online_exam_attempt = AssessmentAttempt.create! valid_attributes
      get :index, {}
      expect(assigns(:online_exam_attempts)).to eq([])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested online_exam_attempt as @online_exam_attempt' do
      online_exam_attempt = AssessmentAttempt.create! valid_attributes
      get :show, id: online_exam_attempt.to_param
      expect(assigns(:online_exam_attempt)).to eq(online_exam_attempt)
    end
  end

  describe 'GET #new' do
    it 'assigns a new online_exam_attempt as @online_exam_attempt' do
      get :new, {}
      expect(assigns(:online_exam_attempt)).to be_a_new(AssessmentAttempt)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new OnlineExamAttempt' do
        subject.current_user.active_course = course1
        expect do
          post :create, assessment_attempt: valid_attributes
        end.to change(AssessmentAttempt, :count).by(1)
      end

      it 'assigns a newly created online_exam_attempt as @online_exam_attempt' do
        post :create, assessment_attempt: valid_attributes
        expect(assigns(:online_exam_attempt)).to be_a(AssessmentAttempt)
        expect(assigns(:online_exam_attempt)).to be_persisted
      end

      it 'redirects to the created online_exam_attempt' do
        post :create, assessment_attempt: valid_attributes
        expect(response).to redirect_to(online_exam_attempt_path(AssessmentAttempt.last))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved online_exam_attempt as @online_exam_attempt' do
        post :create, assessment_attempt: invalid_attributes
        expect(assigns(:online_exam_attempt)).to be_a_new(AssessmentAttempt)
      end

      it "re-renders the 'new' template" do
        post :create, assessment_attempt: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested online_exam_attempt' do
      online_exam_attempt = AssessmentAttempt.create! valid_attributes
      expect do
        delete :destroy, id: online_exam_attempt.to_param
      end.to change(AssessmentAttempt, :count).by(-1)
    end

    it 'redirects to the online_exam_attempts list' do
      online_exam_attempt = AssessmentAttempt.create! valid_attributes
      delete :destroy, id: online_exam_attempt.to_param
      expect(response).to redirect_to(online_exam_attempts_url)
    end
  end
end
