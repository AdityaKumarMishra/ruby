require 'rails_helper'

RSpec.describe "purchase_addons/show", type: :view do
  before(:each) do
    @purchase_addon = assign(:purchase_addon, PurchaseAddon.create!(
      :features => "MyText",
      :subtotal => 1.5,
      :gst => 1.5,
      :paypal_fee => 1.5,
      :paypal_payment => "Paypal Payment",
      :paypal_token => "Paypal Token",
      :banktrans => "Banktrans",
      :paypal => false,
      :bank => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Paypal Payment/)
    expect(rendered).to match(/Paypal Token/)
    expect(rendered).to match(/Banktrans/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
