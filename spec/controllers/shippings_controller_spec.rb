require 'rails_helper'

RSpec.describe ShippingsController, type: :controller do

  let(:user) { FactoryGirl.create(:user, :admin) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all shippings as @shippings" do
      shipping = Shipping.create!
      get :index, {}
      expect(assigns(:shippings)).to eq([shipping])
    end
  end

  describe "GET #new" do
    it "assigns a new shipping as @shipping" do
      get :new, {}
      expect(assigns(:shipping)).to be_a_new(Shipping)
    end
  end

end
