require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  login_student

  let(:user) { FactoryGirl.create(:user) }
  let(:purchase_item) { FactoryGirl.create(:purchase_item) }
  let(:promo) {
    promo = FactoryGirl.create(:promo)
    promo.generate_token!
    promo
  }
  let!(:enrolment) {FactoryGirl.create(:enrolment)}
  let(:valid_attributes) do
    FactoryGirl.attributes_for :order, user_id: user.id, status: "ongoing"
  end

  let(:invalid_attributes) do
    FactoryGirl.attributes_for :order, status: "ongoing"
  end

  describe 'GET #index' do
    it 'assigns all orders user has @orders' do
      order = FactoryGirl.create :order, user_id: subject.current_user.id
      order2 = Order.create! valid_attributes

      get :index, {}
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe 'GET #show' do
    it 'Can see order belong to user' do
      order = FactoryGirl.create :order, user_id: subject.current_user.id
      enrolment = FactoryGirl.create :enrolment
      purchase_item = FactoryGirl.create :purchase_item, order: order, purchasable_type: 'Enrolment', purchasable_id: enrolment.id
      get :show, params: { id: order.to_param }

      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'POST #add_promo' do
    it 'adds promo to ongoing order' do
      order = FactoryGirl.create :order, :ongoing, :with_minimum_spend, user_id: subject.current_user.id
      expect {
        post :add_promo, params: { id: order.id, promo_code: promo.token }
      }.to change { order.promos.count }.by(1)
      expect(response).to redirect_to(order)
    end

    it 'adds promo to non-ongoing order' do
      order = FactoryGirl.create :order, user_id: subject.current_user.id
      expect {
        post :add_promo, params: { id: order.id, promo_code: promo.token }
      }.to change { order.promos.count }.by(0)
      expect(response).to redirect_to(order)
    end
  end

  describe 'DELETE #remove_promo' do
    it 'adds promo to order' do
      order = FactoryGirl.create :order, :ongoing, :with_minimum_spend, user_id: subject.current_user.id
      order.add_promo promo.token

      expect {
        delete :remove_promo, params: { id: order.id, promo_code: promo.token }
      }.to change { order.promos.count }.by(-1)
      expect(response).to redirect_to(order)
    end
  end

  describe 'GET #promo_link' do
    context 'as browser' do
      it 'should redirect' do
        get :promo_link, params: { token: promo.token }
        expect(response).to be_redirect
      end
    end

    context 'as social media' do
      it 'renders metadata' do
        request.env["HTTP_USER_AGENT"] = "Facebot"
        get :promo_link, params: { token: promo.token }
        expect(response).to be_successful
      end
    end
  end


  describe 'POST #share_promo_code' do
    it 'can share promotional code' do
      order = FactoryGirl.create :order, user_id: subject.current_user.id, generated_promo: FactoryGirl.create(:promo, token: 'SAMPLE10')
      emails = "ts-at@gradready.com.au, ts-tt@gradready.com.au"
      post :share_promo_code, params: { id: order.to_param, email: emails }
      expect(response).to redirect_to(order_path(order))
    end
  end

  describe 'GET #display_pending as admin' do
    login_admin
    it 'It displays all pending for admin' do
      order = FactoryGirl.create :order, status: "pending"
      order2 = FactoryGirl.create :order, status: "pending"
      order3 = Order.create! valid_attributes
      get :display_pending, {}
      expect(assigns(:orders)).to eq([order2, order])
    end
  end

  describe 'GET #display_pending as student' do
    login_student
    it 'It displays only pending orders for the user' do
      order = FactoryGirl.create :order, status: "pending", user: subject.current_user
      order2 = FactoryGirl.create :order, status: "pending"
      order3 = Order.create! valid_attributes
      order4 = FactoryGirl.create :order, status: "ongoing", user: subject.current_user
      get :display_pending, {}
      expect(assigns(:orders)).to eq(nil)
    end
  end

  describe 'GET #invoice_pdf' do
    login_admin
    it 'generates PDF' do
      order = FactoryGirl.create :order, :with_minimum_spend, status: "paid", user: user

      get :invoice_pdf, params: { id: order.id }, as: :pdf
      expect(response).to be_successful
      expect(response.headers["Content-Type"]).to eq("application/pdf")
    end
  end

  describe 'GET #payment_success' do
    it 'generates PDF' do
      order = FactoryGirl.create :order, :with_minimum_spend, status: "paid", user: subject.current_user
      subject.current_user.update(payment_flow_step: "orders/#{order.id}")

      get :payment_success, params: { id: order.id }
      expect(response).to be_successful
      expect(subject.current_user.reload.payment_flow_step).to eq(nil)
    end
  end

  describe 'POST #add_to_cart' do
    it 'adds on to order' do
      order = FactoryGirl.create :order, :with_minimum_spend, status: "paid", user: subject.current_user
      enrolment = order.purchase_items.first.purchasable
      course = enrolment.course
      pvfp = FactoryGirl.create :product_version_feature_price, product_version: course.product_version

      expect {
        get :add_to_cart, params: { id: order.id, pvfp_id: pvfp.id, enrolment_id: enrolment.id, qty: nil }
      }.to change { order.purchase_items.count }.by(1)
    end
  end

  describe 'POST #textbook_cart' do
    it 'adds on to order' do
      order = FactoryGirl.create :order, :with_minimum_spend, status: "paid", user: subject.current_user
      enrolment = order.purchase_items.first.purchasable
      course = enrolment.course
      pvfp = FactoryGirl.create :product_version_feature_price, :with_hardcopy, product_version: course.product_version

      get :textbook_cart, params: { id: order.id, pvfp_id: pvfp.id, enrolment_id: enrolment.id, online_check: 1, hardcopy_checked: 1 }
      expect(enrolment.reload.online_textbook).to be_truthy
      expect(enrolment.reload.hardcopy).to be_truthy
    end
  end

  describe 'GET #client_token' do
    it 'generates JSON for tokens' do
      order = FactoryGirl.create :order, :with_minimum_spend, status: "paid", user: user

      get :client_token
      expect(response).to be_successful
      expect(response.headers["Content-Type"]).to include("application/json")
      expect(response.parsed_body['client_token']).to be_present
    end
  end

  describe 'POST #empty_cart' do
    it 'Removes all purchase items associated with the current order' do
      order = FactoryGirl.create :order, status: "ongoing", user: subject.current_user
      purchase_item = FactoryGirl.create :purchase_item, order: order
      purchase_item2 = FactoryGirl.create :purchase_item, order: order
      expect {
        post :empty_cart, params: { id: order.id }
      }.to change { order.purchase_items.count }.by(-2)
      expect(response).to redirect_to(order_path(-1, placeholder: true))
    end
  end

  describe 'POST #paypal_complete' do
    it 'completes purchase' do
      order = FactoryGirl.create :order, :with_minimum_spend, status: "ongoing", user: subject.current_user

      post :paypal_complete, params: { id: order.id, payment_method_nonce: 'fake-valid-nonce' }
      expect(order.reload.status).to eq('paid')
    end
  end

  describe 'POST #direct_complete' do
    it 'marks payment pending' do
      order = FactoryGirl.create :order, :with_minimum_spend, status: "ongoing", user: subject.current_user

      post :direct_complete, params: { id: order.id }
      expect(order.reload.status).to eq('pending')
    end
  end

  describe 'POST #confirm_paid' do
    login_admin
    it 'Decreases number of pending purchases by one' do
      order = FactoryGirl.create :order, status: "ongoing"
      order2 = FactoryGirl.create :order, :with_minimum_spend, status: "pending", user: user
      order3 = FactoryGirl.create :order, status: "paid"


      expect {
        post :confirm_paid, params: { id: order2.id }
      }.to change {Order.where(status: 1).count}.by(-1)
    end

    it 'Increases number of paid purchases by one' do
      order = FactoryGirl.create :order, status: "ongoing"
      order2 = FactoryGirl.create :order, :with_minimum_spend, status: "pending", user: user
      order3 = FactoryGirl.create :order, status: "paid"

      expect {
        post :confirm_paid, params: { id: order2.id }
      }.to change {Order.where(status: 2).count}.by(1)

    end
  end

  describe "#redact_order" do
    let(:status) do
      FactoryGirl.attributes_for(:order, status: 'pending')
    end
    let(:status2) do
      FactoryGirl.attributes_for(:order, status: 'ongoing')
    end
    it 'updates the examinable column' do
      order = Order.create! valid_attributes
      get :redact_order, params: { id: order.id }
      expect(order.status).to eq('ongoing')
    end
    it 'fails to redact payment' do
      order = Order.create! valid_attributes
      get :redact_order, params: { id: order.id }
      expect(order.status).to eq('ongoing')
    end
  end

  describe 'PUT #unsubscribe_popup' do
    before(:each) { sign_in user }
    it 'marks popup as seen' do
      expect { put :unsubscribe_popup }.to change { user.reload.seen_discount_popup }.to true
    end
  end
end
