require 'rails_helper'

RSpec.describe "purchase_addons/edit", type: :view do
  before(:each) do
    @purchase_addon = assign(:purchase_addon, PurchaseAddon.create!(
      :features => "MyText",
      :subtotal => 1.5,
      :gst => 1.5,
      :paypal_fee => 1.5,
      :paypal_payment => "MyString",
      :paypal_token => "MyString",
      :banktrans => "MyString",
      :paypal => false,
      :bank => false
    ))
  end

  it "renders the edit purchase_addon form" do
    render

    assert_select "form[action=?][method=?]", purchase_addon_path(@purchase_addon), "post" do

      assert_select "textarea#purchase_addon_features[name=?]", "purchase_addon[features]"

      assert_select "input#purchase_addon_subtotal[name=?]", "purchase_addon[subtotal]"

      assert_select "input#purchase_addon_gst[name=?]", "purchase_addon[gst]"

      assert_select "input#purchase_addon_paypal_fee[name=?]", "purchase_addon[paypal_fee]"

      assert_select "input#purchase_addon_paypal_payment[name=?]", "purchase_addon[paypal_payment]"

      assert_select "input#purchase_addon_paypal_token[name=?]", "purchase_addon[paypal_token]"

      assert_select "input#purchase_addon_banktrans[name=?]", "purchase_addon[banktrans]"

      assert_select "input#purchase_addon_paypal[name=?]", "purchase_addon[paypal]"

      assert_select "input#purchase_addon_bank[name=?]", "purchase_addon[bank]"
    end
  end
end
