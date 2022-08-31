require 'rails_helper'

RSpec.describe MasterFeature, type: :model do
  it { should have_many(:product_version_feature_prices) }
  it { should have_many(:product_versions).through(:product_version_feature_prices) }
  it { should have_many(:feature_logs).through(:product_version_feature_prices) }
  it { should have_many(:enrolments).through(:feature_logs) }

  describe '#private_tutoring?' do
    it 'should return true for private tutoring master feature' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatPrivateTutoringFeature')
      expect(master_feature.private_tutoring?).to eq(true)
    end

    it 'should return false for non private tutoring master feature' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatExamFeature')
      expect(master_feature.private_tutoring?).to eq(false)
    end
  end

  describe '#essay?' do
    it 'should return true for essay master feature' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatEssayFeature')
      expect(master_feature.essay?).to eq(true)
    end

    it 'should return false for non essay master feature' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatVideoFeature')
      expect(master_feature.essay?).to eq(false)
    end
  end

  describe '#friendly_feature_name' do
    xit 'should return master feature friendly name' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatEssayFeature')
      expect(master_feature.friendly_feature_name).to eq('Gamsat Essay Feature')
    end
  end

  describe '#product_version_feature_price' do
    it 'should return product version feature price' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatEssayFeature')
      product_version = FactoryGirl.create(:product_version)
      pvfp = FactoryGirl.create(:product_version_feature_price,
                                master_feature: master_feature,
                                product_version: product_version
                               )
      expect(master_feature.product_version_feature_price(product_version.id)).to eq(pvfp)
    end
  end

  describe '#get_clarity?' do
    it 'Return true if feature is GetClarity' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatGetClarityFeature')
      expect(master_feature.get_clarity?).to eq(true)
    end
  end

  describe 'Order master features' do
    it 'it should return ordered master features' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatGetClarityFeature')
      master_feature1 = FactoryGirl.create(:master_feature, name: 'GamsatDiagnosticsFeature', position: 1)
      master_feature2 = FactoryGirl.create(:master_feature, name: 'GamsatMcqFeature', position: 2)
      expect(MasterFeature.all.order(:position)).to eq([master_feature1, master_feature2, master_feature])
    end
  end

  describe '#hardcopy?' do
    it 'should return true for textbook hardcopy master feature' do
      master_feature = FactoryGirl.create(:master_feature, name: 'TextbookHardCopyFeature')
      expect(master_feature.hardcopy?).to eq(true)
    end

    it 'should return false for non textbook hardcopy master feature' do
      master_feature = FactoryGirl.create(:master_feature, name: 'GamsatExamFeature')
      expect(master_feature.hardcopy?).to eq(false)
    end
  end
end
