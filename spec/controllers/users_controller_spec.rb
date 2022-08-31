require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  login_admin


  let(:user) {
    FactoryGirl.create(:user)
  }
  let(:user_attributes) {
    FactoryGirl.attributes_for(:user).merge!({
      address_attributes: FactoryGirl.attributes_for(:address, state: "victoria" , country: "australia")
    })
  }
  let(:questionnaire_attributes) {
    FactoryGirl.attributes_for(:questionnaire).merge!({
      university_id: FactoryGirl.create(:university).id,
      degree_id: FactoryGirl.create(:degree).id,
      student_region: :domestic,
      user_id: user.id
    })
  }

  let(:user1) {
    FactoryGirl.create(:user)
  }

  describe '#update' do
    context 'with a password' do
      let(:new_password) {
        "TESTNEWPASSWORD"
      }

      it "updates the password" do
        old_password = user.encrypted_password
        user_attributes[:password] = new_password
        put :update,params: { id: user.id, user: user_attributes }
        user.reload
        new_password = user.encrypted_password
        expect(old_password).not_to eq new_password
      end
    end

    context 'without a password' do
      it "not update the password" do
        old_password = user.encrypted_password
        user_attributes[:password] = ''
        put :update,params: { id: user.id, user: user_attributes }
        user.reload
        new_password = user.encrypted_password
        expect(old_password).to eq new_password
      end
    end

    context 'without a questionnaire' do
      it "creates a questionaire" do
        user_attributes.merge!({
          questionnaire_attributes: questionnaire_attributes
        })
        put :update,params: { id: user.id, user: user_attributes }
        user.reload
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'with a questionnaire' do
      let(:user_with_questionnaire) {
        FactoryGirl.create(:questionnaire, questionnaire_attributes)
      }

      it "updates a questionaire" do
        old_year = user_with_questionnaire.year
        questionnaire_attributes[:year] = '2015'
        user_attributes.merge!({
          questionnaire_attributes: questionnaire_attributes
        })
        put :update,params: { id: user_with_questionnaire.user_id, user: user_attributes }
        user_with_questionnaire.reload
        expect(user_with_questionnaire.year).not_to eq(old_year)
      end
    end

    context 'with an invalid questionnaire' do
      let(:invalid_questionnaire_attributes) {
        FactoryGirl.attributes_for(:questionnaire)
      }

      it "raises an validation error" do
        user_attributes.merge!({
          questionnaire_attributes: invalid_questionnaire_attributes
        })
        expect {
          put :update,params: { id: user.id, user: user_attributes }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#create' do
    context 'with valid attributes' do
      login_admin
      it "redirect to root path" do
        expect {
          post :create, params: { user: user_attributes }
        }.to change { User.count }.by(1)
        expect(response).to redirect_to user_emails_path
      end
    end

    context 'with invalid attributes' do
      login_admin
      it 'it should deactivate or activate the account' do
        post :create, params: { user: { email: 'a@b.com' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#destroy' do
    context 'with admin logged in' do
      login_admin
      it "destroys user" do
        delete :destroy, params: { id: user.id }
        expect{ user.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to redirect_to user_emails_path
      end
    end
  end

  describe '#destroy_ongoing_orders' do
    context 'with student has multiple ongoing orders' do
      login_student

      it "destroys user ongoing orders" do
        FactoryGirl.create(:enrolment)
        2.times do
          subject.current_user.orders.create!(status: :ongoing)
        end

        expect {
          delete :destroy_ongoing_orders
        }.to change { subject.current_user.orders.count }.by(-2)
      end
    end
  end

  describe '#generate_new_password_email' do
    context 'with student' do
      login_student

      it "generates reset password email" do
        post :generate_new_password_email, params: { user_id: subject.current_user.id }
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
  end

  describe '#deactivate' do
    context 'deactivate while login with student' do
      login_student
      it "redirect to root path" do
        put :deactivate, params: { id: user.id, status: 'deactivated' }
        expect(response).to redirect_to root_path
      end
    end

    context 'deactivate while login with admin' do
      login_superadmin
      it 'it should deactivate or activate the account' do
        put :deactivate, params: { id: user.id, status: 'deactivated' }
        expect(response).to redirect_to user_emails_path
      end
    end
  end


  describe '#become' do
    context 'become while login with student' do
      login_student
      it "should denied access" do
        get :become, params: { user_id: user1.id }
        expect(flash[:alert]).to match(/Oops! There seems to be something wrong. Please send through an issue ticket using the button below.*/)
      end
    end

    context 'become while login with admin' do
      login_superadmin
      it 'it should allow access' do
        get :become, params: { user_id: user1.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#check_email' do
    context 'when email is not present in db' do
      it 'it should return true' do
        get :check_email, params: { user: {email: "xxyyzz@xyz.com"} }, as: :json
        expect(response.body).to eq "true"
      end
    end

    context 'when email is already taken' do
      it 'it should return false' do
        get :check_email, params: { user: {email: user.email} }, as: :json
        expect(response.body).to eq "false"
      end
    end
  end

  describe '#destroy_all' do
    context 'with admin logged in' do
      login_admin
      it "destroys users" do
        delete :destroy_all, params: { user_ids: "#{user.id}  #{user1.id}" }
        expect{ user.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect{ user1.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to redirect_to user_emails_path
      end
    end
  end

  describe '#resend_invitation' do
    login_superadmin
    it 'it should resend invitation' do
      put :resend_invitation, params: { id: user.id }
      expect(response).to redirect_to user_emails_path
      expect(flash[:notice]).to match(/User already accepted invitation!*/)
    end
  end

  describe '#reset_ol_exam' do
    login_superadmin
    let(:pl) { FactoryGirl.create(:product_line) }
    let(:exam) { FactoryGirl.create(:online_exam, position: 1, product_line_id: pl.id) }
    let!(:attempt) { FactoryGirl.create(:assessment_attempt, assessable: exam, user_id: user.id) }

    it 'it should reset exam' do
      expect {
        get :reset_ol_exam, params: { exam_id: attempt.id, user_id: user.id, enrolment_id: 1 }, xhr: true
      }.to change { exam.assessment_attempts.count }.by(-1)
    end
  end

  describe '#reset_online_mock_exam_attempt' do
    login_superadmin
    let(:exam) { OnlineMockExam.create }
    let!(:attempt) { FactoryGirl.create(:assessment_attempt, assessable: exam, user_id: user.id) }

    it 'it should reset online mock exam' do
      get :reset_online_mock_exam_attempt, params: { online_mock_exam_at_id: attempt.id, user_id: user.id, enrolment_id: 1 }, xhr: true
      expect { attempt.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#reset_diganostic' do
    login_superadmin
    let(:exam) { FactoryGirl.create(:diagnostic_test) }
    let!(:attempt) { FactoryGirl.create(:assessment_attempt, assessable: exam, user_id: user.id) }

    it 'it should reset diagnostic exam' do
      expect {
        get :reset_diganostic, params: { diagnostic_id: attempt.id, user_id: user.id, enrolment_id: 1 }, xhr: true
      }.to change { exam.assessment_attempts.count }.by(-1)
    end
  end

  describe '#cancel_appointment' do
    login_superadmin
    let(:course) { FactoryGirl.create(:course) }
    let!(:appointment) { FactoryGirl.create(:appointment, student: user, course: course, status: :active) }

    it 'it should cancel appointment' do
      get :cancel_appointment, params: { appointment_id: appointment.id, user_id: user.id, enrolment_id: 1 }, xhr: true
      expect(appointment.reload.status).to eq('deleted')
    end
  end

  describe '#reset_essay' do
    login_superadmin
    let(:pl) { FactoryGirl.create(:product_line) }
    let(:essay) { FactoryGirl.create(:essay, position: 1, product_line_id: pl.id) }
    let!(:attempt) { FactoryGirl.create(:essay_response, essay: essay, user_id: user.id) }

    it 'it should reset essay' do
      get :reset_essay, params: { expiry_date: Date.tomorrow , essay_response_id: attempt.id, user_id: user.id, enrolment_id: 1 }, xhr: true
      attempt.reload

      expect(attempt.elapsed_time).to eq(0)
      expect(attempt.time_submited).to be_nil
      expect(attempt.expiry_date > Time.zone.now).to be_truthy
    end
  end

  describe '#reset_mock_exam' do
    login_superadmin
    let(:course) { FactoryGirl.create(:course) }
    let!(:live_exam) { FactoryGirl.create(:live_exam, user: user, course: course) }

    it 'it should reset live exam' do
      expect {
        get :reset_mock_exam, params: { user_id: user.id, enrolment_id: 1 }, xhr: true
      }.to change { user.live_exams.count }.by(-1)
    end
  end
end
