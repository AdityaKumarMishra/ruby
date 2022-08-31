require 'rails_helper'

RSpec.describe FeatureLogsController, type: :controller do
  login_student
  let(:valid_session) { {} }

  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:master_feature1) { FactoryGirl.create(:master_feature, name: 'GamsatMcqFeature') }
  let!(:master_feature2) { FactoryGirl.create(:master_feature, name: 'GamsatDocumentFeature') }
  let!(:master_feature3) { FactoryGirl.create(:master_feature, name: 'GamsatVideoFeature') }
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: subject.current_user) }
  let!(:pvfp1) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature1,
                       product_version: productVer, is_default: true
                      )
  end

  let!(:pvfp2) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature2,
                       product_version: productVer, qty: 5, is_default: false
                      )
  end

  let!(:pvfp3) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature3,
                       product_version: productVer, is_default: false
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

  let!(:feature_log2) do
    FactoryGirl.create(:feature_log,
                       product_version_feature_price: pvfp2, enrolment: enrolment,
                       qty: pvfp2.qty
                      )
  end

  let!(:feature_log3) do
    FactoryGirl.create(:feature_log,
                       product_version_feature_price: pvfp3, enrolment: enrolment
                      )
  end

  let!(:current_order) do
    FactoryGirl.create(:order, user: subject.current_user, status: 'ongoing')
  end

  let!(:pending_order) do
    FactoryGirl.create(:order, user: subject.current_user, status: 'pending')
  end
  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: subject.current_user, order: order, purchasable: enrolment) }

  describe 'GET #index' do
    xit 'correctly assigns the users non-active non-purchase_items as @inactive' do
      subject.current_user.update_attribute(:active_course_id, course1.id)
      get :index, {}, valid_session
      expect(assigns(:inactive)).to eq([pvfp2, pvfp3])
    end

    xit 'correctly determines the featurettes in the cart' do
      FactoryGirl.create(:purchase_item,
                         order: current_order,
                         user: subject.current_user,
                         purchasable: feature_log2
                        )

      get :index, {}, valid_session
      expect(assigns(:in_cart)).to eq([pvfp2])
    end

    xit 'correctly determines which features are awaiting direct deposit confirmation' do
      FactoryGirl.create(:purchase_item,
                         order: pending_order,
                         user: subject.current_user,
                         purchasable: feature_log3
                        )
      get :index, {}, valid_session
      expect(assigns(:pending_confirmation)).to eq([pvfp3])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested feature_log as @feature_log' do
      get :show, { id: feature_log1.to_param }, valid_session
      expect(assigns(:feature_log)).to eq(feature_log1)
    end
  end

  describe 'GET #add_to_cart' do
    it 'creates a purchase_item' do
      subject.current_user.update_attribute(:active_course_id, course1.id)
      expect do
        get :add_to_cart, { id: pvfp2.to_param }, valid_session
      end.to change(PurchaseItem, :count).by(1)
    end

    it 'matches feature_log with a purchase_item of current cart' do
      subject.current_user.update_attribute(:active_course_id, course1.id)
      get :add_to_cart, { id: pvfp2.to_param }, valid_session
      PurchaseItem.exists?(purchasable_id: feature_log2.id,
                           purchasable_type: feature_log2.class.name
                          ) == true
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested feature_log' do
      feature_log = FactoryGirl.create(:feature_log)
      expect do
        delete :destroy, { id: feature_log.to_param }, valid_session
      end.to change(FeatureLog, :count).by(-1)
    end

    it 'redirects to the feature logs list' do
      feature_log = FactoryGirl.create(:feature_log)
      delete :destroy, { id: feature_log.to_param }, valid_session
      expect(response).to redirect_to(feature_logs_path)
    end
  end

  describe 'GET #find_feature_price', js: true do
    it 'it assigns product version feature price for add to cart' do
       xhr :get, 'find_feature_price', { id: pvfp1.to_param }, :format => 'js'
      expect(assigns(:pvfp)).to eq(pvfp1)
    end
  end
end
