require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ProductVersionsHelper. For example:
#
# describe ProductVersionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

RSpec.describe ProductVersionsHelper, type: :helper do
  describe '#recreate_pvfps(pvfps, product_version)' do
    let!(:product_version) { FactoryGirl.create(:product_version, name: 'custom', course_type: 1, type: 'GamsatReady') }
    let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatPrivateTutoringFeature') }
    let!(:product_version_feature_price) do
      FactoryGirl.create(:product_version_feature_price,
                         product_version_id: product_version.id,
                         master_feature_id: master_feature.id,
                         qty: 6, is_additional: false, price: 5.00)
    end

    let(:pvfps) { ProductVersionFeaturePrice.where(id: product_version_feature_price.id) }

    before do
      @new_pvfps = helper.recreate_pvfps(pvfps, product_version)
    end

    it 'return array of the same size' do
      expect(@new_pvfps.size).to eq(1)
    end

    it 'has the qty as set for custom courses' do
      expect(@new_pvfps.first.qty).to eq(6)
    end

    it 'has the same master feature' do
      expect(@new_pvfps.first.master_feature_id).to eq(master_feature.id)
    end

    it 'does not contain the same pvfp because it has been transformed' do
      expect(@new_pvfps.first.id).not_to eq(product_version_feature_price.id)
    end

    it 'changes the pvfp to is_additional' do
      expect(@new_pvfps.first.is_additional).to eq(true)
    end

    it 'updates the pvfp price' do
      expect(@new_pvfps.first.price).to eq(30.00)
    end
  end
end
