require 'rails_helper'

RSpec.describe EnrolmentsController, type: :controller do
  login_superadmin

  let(:course) { FactoryGirl.create(:course) }
  let(:user) { FactoryGirl.create(:user) }
  let!(:productVer) { FactoryGirl.create(:product_version) }
  let(:valid_attributes) do
    FactoryGirl.attributes_for :enrolment, course_id: course.id
  end

  let(:invalid_attributes) do
    { course_id: nil }
  end
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: user) }
  let!(:enrolment) { FactoryGirl.create(:enrolment) }
  let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
  let!(:pvfp) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature,
                       product_version: productVer, is_default: true
                      )
  end
  let!(:feature_log) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                     acquired: DateTime.now, enrolment: enrolment
                      )
  end
  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: user, order: order, purchasable: enrolment) }
  let!(:promo) { FactoryGirl.create(:promo, generated_from_id: order.id) }

  describe 'GET #show' do
    it 'assigns the requested enrolment as @enrolment' do
      get :show, id: enrolment.to_param, user_id: user.id
      expect(assigns(:enrolment)).to eq(enrolment)
    end
  end

  describe 'GET #show' do
    it 'catch the error if enrolment not found' do
      expect { get :show, {id: 'ewr2342234', user_id: user.id}}.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'GET #new' do
    it 'assigns a new enrolment as @enrolment' do
      get :new, course_id: course.id, user_id: user.id
      expect(assigns(:enrolment)).to be_a_new(Enrolment)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested enrolment as @enrolment' do
      get :edit, id: enrolment.to_param, user_id: user.id
      expect(assigns(:enrolment)).to eq(enrolment)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Enrolment' do
        expect do
          post :create, enrolment: valid_attributes, user_id: user.id, course_id: course.id
        end.to change(Enrolment, :count).by(1)
      end

      it 'assigns a newly created enrolment as @enrolment' do
        post :create, enrolment: valid_attributes, user_id: user.id, course_id: course.id
        expect(assigns(:enrolment)).to be_a(Enrolment)
        expect(assigns(:enrolment)).to be_persisted
      end

      it 'redirects to the created enrolment' do
        post :create, enrolment: valid_attributes, user_id: user.id, course_id: course.id
        expect(response).to redirect_to(user_enrolment_path(user, Enrolment.last))
      end
    end

    context 'with invalid params' do

      pending(it 'assigns a newly created but unsaved enrolment as @enrolment') # do

      #   post :create, enrolment: invalid_attributes, user_id: user.id
      #   expect(assigns(:enrolment)).to be_a_new(Enrolment)
      # end

      pending(it "re-renders the 'new' template")# do
      #   post :create, enrolment: invalid_attributes, user_id: user.id
      #   expect(response).to render_template('new')
      # end
    end
  end

  describe 'POST #transfer_course' do
    context 'with valid params' do
      let!(:user1) { FactoryGirl.create(:user) }
      let!(:productVer1) { FactoryGirl.create(:product_version) }

      let!(:essays) do
        (1..10).map do |i|
          FactoryGirl.create(:essay, product_line_id: productVer1.product_line_id, position: i)
        end
      end

      let!(:course1) { FactoryGirl.create(:course, product_version_id: productVer1.id) }
      let!(:course2) { FactoryGirl.create(:course, product_version_id: productVer1.id) }
      let!(:order1) { FactoryGirl.create(:order, status: :paid, user_id: user1.id) }
      let!(:enrolment1) { FactoryGirl.create(:enrolment, paid_at: DateTime.now, course_id: course1.id) }
      let!(:master_feature1) { FactoryGirl.create(:master_feature, name: 'GamsatEssayFeature', title: 'Essays') }

      let!(:pvfp1) do
        FactoryGirl.create(:product_version_feature_price,
                           master_feature: master_feature1,
                           product_version: productVer1, is_default: true, qty: 10
                          )
      end

      let!(:tagging) do
        essays.map { |e| FactoryGirl.create(:tagging, tag_id: pvfp1.tags.first.id, taggable: e) }
      end

      let!(:feature_log1) do
        FactoryGirl.create(:feature_log, product_version_feature_price: pvfp1,
                                         acquired: DateTime.now, enrolment: enrolment1, qty: 10
                          )
      end

      let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: user1, order: order1, purchasable: enrolment1) }
      let!(:promo) { FactoryGirl.create(:promo, generated_from_id: order1.id) }

      before do
        enrolment1.reload.activate
      end

      it 'transfers exactly the same essays' do
        essay_responses_course_1 = user1.essay_responses.where(course_id: course1.id).pluck(:id, :essay_id, :time_submited, :status, :expiry_date).sort_by(&:first)

        post :transfer_course, params: { user_id: user1.id, enrolment_id: enrolment1.id, course_id: course2.id }

        expect(user1.reload.enrolments.count).to eq(2)
        expect(user1.reload.enrolments.order(:created_at).last.course_id).to eq(course2.id)

        essay_responses_course_2 = user1.reload.essay_responses.where(course_id: course2.id).pluck(:id, :essay_id, :time_submited, :status, :expiry_date).sort_by(&:first)
        expect(essay_responses_course_1).to eq(essay_responses_course_2)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { paypal_payment: 'some valid payment id 111' }
      end

      it 'updates the requested enrolment' do
        put :update, id: enrolment.to_param, enrolment: new_attributes, user_id: user.id
        enrolment.reload
        expect(enrolment.paypal_payment).to eq 'some valid payment id 111'
      end

      it 'assigns the requested enrolment as @enrolment' do
        put :update, id: enrolment.to_param, enrolment: valid_attributes, user_id: user.id
        expect(assigns(:enrolment)).to eq(enrolment)
      end

      it 'redirects to the enrolment' do
        put :update, id: enrolment.to_param, enrolment: valid_attributes, user_id: user.id
        expect(response).to redirect_to(user_enrolment_path(user, enrolment))
      end
    end

    context 'with invalid params' do
      it 'assigns the enrolment as @enrolment' do
        put :update, id: enrolment.to_param, enrolment: invalid_attributes, user_id: user.id
        expect(assigns(:enrolment)).to eq(enrolment)
      end

      it "re-renders the 'edit' template" do
        put :update, id: enrolment.to_param, enrolment: invalid_attributes, user_id: user.id
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested enrolment' do
      expect do
        delete :destroy, params: { id: enrolment.to_param, user_id: user.id }
      end.to change(Enrolment, :count).by(-1)
    end

    it 'redirects to the enrolments list' do
      delete :destroy, params: { id: enrolment.to_param, user_id: user.id }
      expect(response).to redirect_to(edit_user_path(user))
    end
  end
end
