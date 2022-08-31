# require 'rails_helper'

# RSpec.describe "featurettes/index", type: :view do
#   login_student
#   before(:each) do

#     fe = FactoryGirl.create(:feature_enrolment)
#     current_order = FactoryGirl.create(:order, status: "ongoing")

#     # without purchase items
#     featurette1 = FactoryGirl.create(:featurette, feature_enrolment: fe)
#     featurette2 = FactoryGirl.create(:featurette, feature_enrolment: fe)

#     # with purchase items (i.e. in a cart or pending)
#     featurette3 = FactoryGirl.create(:featurette, feature_enrolment: fe)
#     purchase_item3 = FactoryGirl.create(:purchase_item, order: current_order, purchasable: featurette3)
#     featurette4 = FactoryGirl.create(:featurette, feature_enrolment: fe)
#     purchase_item4 = FactoryGirl.create(:purchase_item, order: current_order, purchasable: featurette4)

#     assign(:inactive, [featurette1, featurette2])
#     assign(:in_cart, [featurette3, featurette4])
#     assign(:pending_confirmation, [featurette3, featurette4])

#   end

#   it "renders a list of featurettes" do
#     render
#     assert_select "tr>td", :text => Feature.first.name.to_s.split(/(?=[A-Z])/).join(' ').to_s, :count => 6
#     # assert_select "tr>td", :text => "Options".to_s, :count => 2
#     assert_select "tr>td", :text => "$9.99", :count => 6
#     assert_select "tr>td", :text => "Not In Cart", :count => 2
#     assert_select "tr>td", :text => "In Cart", :count => 3 # the third one is the link to the cart
#     assert_select "tr>td", :text => "Awaiting Confirmation", :count => 2
#     assert_select "tr>td", :text => "3 hours", :count => 6
#   end
# end
