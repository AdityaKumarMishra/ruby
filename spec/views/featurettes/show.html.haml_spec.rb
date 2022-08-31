# require 'rails_helper'

# RSpec.xdescribe "featurettes/show", type: :view do
#   before(:each) do
#     product = FactoryGirl.create(:product_version)
#     feat = FactoryGirl.create(:feature, product_version: product)
#     fe = FactoryGirl.create(:feature_enrolment, feature: feat)
#     featurette = FactoryGirl.create(:featurette, feature_enrolment: fe)
#     @featurette = assign(:featurette, featurette)
#     featurette_feature = @featurette.feature_enrolment.feature
#   end

#   it "renders attributes in <p>" do
#     render
#     expect(rendered).to match(featurette_feature.first.name.to_s.split(/(?=[A-Z])/).join(' ')) if featurette_feature
#     expect(rendered).to match("GamsatReady")
#     expect(rendered).to match("<b>Cost (excluding GST):</b>")
#     expect(rendered).to match("$9.99")
#   end
# end
