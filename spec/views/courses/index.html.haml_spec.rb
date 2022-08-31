require 'rails_helper'

RSpec.describe "courses/index", type: :view do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let!(:order1) { FactoryGirl.create(:order, status: :paid, user: user1) }
  let!(:order2) { FactoryGirl.create(:order, status: :paid, user: user2) }

  before(:each) do
    sign_in user1
    assign(:courses, [
      course1 = Course.create!(
        :name => "Name",
        :class_size => 5,
        :student_count => 2,
        :product_version_id => 3
      ),
      course2 = Course.create!(
        :name => "Name",
        :class_size => 5,
        :student_count => 2,
        :product_version_id => 3
      )
    ])
    enrolment1 = Enrolment.create!(course: course1, paid_at: Time.zone.now, paypal_token: 'some token', paypal_payment: 'some payment id')
    enrolment2 = Enrolment.create!(course: course2, paid_at: Time.zone.now, paypal_token: 'some token', paypal_payment: 'some payment id')

    PurchaseItem.create!(user: user1, order: order1, purchasable: enrolment1, initial_cost: "9.99", added_gst: "9.99", method_fee: "9.99", purchase_description: "MyString")
    PurchaseItem.create!(user: user1, order: order2, purchasable: enrolment2, initial_cost: "9.99", added_gst: "9.99", method_fee: "9.99", purchase_description: "MyString")
    PurchaseItem.create!(user: user2, order: order1, purchasable: enrolment1, initial_cost: "9.99", added_gst: "9.99", method_fee: "9.99", purchase_description: "MyString")
    PurchaseItem.create!(user: user2, order: order2, purchasable: enrolment2, initial_cost: "9.99", added_gst: "9.99", method_fee: "9.99", purchase_description: "MyString")
  end

  xit "renders a list of courses" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2

  end
end
