require 'rails_helper'

RSpec.describe DiagnosticTestAttemptsController, type: :controller do
  login_student
  let(:diagnostic_test) { FactoryGirl.create :diagnostic_test, published: true }
  let(:valid_attributes) do
    { user_id: subject.current_user.id, assessable_id: diagnostic_test.id, assessable_type: "DiagnosticTest" }
  end

  let(:invalid_attributes) do
    { assessable_id: nil }
  end

  describe 'GET #index' do
    xit 'assigns all diagnostic_test_attempts as @diagnostic_test_attempts' do
      productVer = FactoryGirl.create(:product_version, type: 'GamsatReady')
      course = FactoryGirl.create(:course, product_version_id: productVer.id)
      order = FactoryGirl.create(:order, status: :paid, user: subject.current_user)
      enrolment = FactoryGirl.create(:enrolment)
      paid_purchase_item = FactoryGirl.create(:purchase_item, user: subject.current_user, order: order, purchasable: enrolment)
      announcement = FactoryGirl.create(:announcement, name: 'GamsatReady-dashboard',
                                                       category: 'Dashboardpage', description: 'dashboard announcements'
                                       )
      subject.current_user.active_course = course
      diagnostic_test_attempt = AssessmentAttempt.create! valid_attributes
      get :index, {}
      expect(assigns(:diagnostic_test_attempts)).to eq([])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested diagnostic_test_attempt as @diagnostic_test_attempt' do
      diagnostic_test_attempt = AssessmentAttempt.create! valid_attributes
      get :show, id: diagnostic_test_attempt.to_param
      expect(assigns(:diagnostic_test_attempt)).to eq(diagnostic_test_attempt)
    end
  end

  describe 'GET #new' do
    it 'assigns a new diagnostic_test_attempt as @diagnostic_test_attempt' do
      get :new, {}
      expect(assigns(:diagnostic_test_attempt)).to be_a_new(AssessmentAttempt)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new DiagnosticTestAttempt' do
        expect do
          post :create, assessment_attempt: valid_attributes
        end.to change(AssessmentAttempt, :count).by(1)
      end

      it 'assigns a newly created diagnostic_test_attempt as @diagnostic_test_attempt' do
        post :create, assessment_attempt: valid_attributes
        expect(assigns(:diagnostic_test_attempt)).to be_a(AssessmentAttempt)
        expect(assigns(:diagnostic_test_attempt)).to be_persisted
      end

      it 'redirects to the created diagnostic_test_attempt' do
        post :create, assessment_attempt: valid_attributes
        expect(response).to redirect_to(diagnostic_test_attempt_path(AssessmentAttempt.last))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved diagnostic_test_attempt as @diagnostic_test_attempt' do
        post :create, assessment_attempt: invalid_attributes
        expect(assigns(:diagnostic_test_attempt)).to be_a_new(AssessmentAttempt)
      end

      it "re-renders the 'new' template" do
        post :create, assessment_attempt: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested diagnostic_test_attempt' do
      diagnostic_test_attempt = AssessmentAttempt.create! valid_attributes
      expect do
        delete :destroy, id: diagnostic_test_attempt.to_param
      end.to change(AssessmentAttempt, :count).by(-1)
    end

    it 'redirects to the diagnostic_test_attempts list' do
      diagnostic_test_attempt = AssessmentAttempt.create! valid_attributes
      delete :destroy, id: diagnostic_test_attempt.to_param
      expect(response).to redirect_to(diagnostic_test_attempts_url)
    end
  end
end
