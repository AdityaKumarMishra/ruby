require 'rails_helper'

RSpec.describe "purchase_addons/index", type: :view do
  before(:each) do
    assign(:purchase_addons, [
      PurchaseAddon.create!(
        :features => "t1",
        :subtotal => 11,
        :gst => 1,
        :paypal_fee => 0.25,
        :paypal_payment => "Paypal Payment1",
        :paypal_token => "Paypal Token1",
        :banktrans => "Banktrans1",
        :paypal => true,
        :bank => false
      ),
      PurchaseAddon.create!(
        :features => "t2",
        :subtotal => 100,
        :gst => 10,
        :paypal_fee => 2,
        :paypal_payment => "Paypal Payment2",
        :paypal_token => "Paypal Token2",
        :banktrans => "Banktrans2",
        :paypal => true,
        :bank => false
      )
    ])
  end

  it "renders a list of purchase_addons" do
    render
    assert_select "tr>td", :text => "t1".to_s, :count => 1
    assert_select "tr>td", :text => "t2".to_s, :count => 1
    assert_select "tr>td", :text => "Paypal Payment1".to_s, :count => 1
    assert_select "tr>td", :text => "Paypal Token1".to_s, :count => 1
    assert_select "tr>td", :text => "Banktrans1".to_s, :count => 1
    assert_select "tr>td", :text => "Paypal Payment2".to_s, :count => 1
    assert_select "tr>td", :text => "Paypal Token2".to_s, :count => 1
    assert_select "tr>td", :text => "Banktrans2".to_s, :count => 1
    assert_select "tr>td", :text => true.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
