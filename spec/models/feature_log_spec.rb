require 'rails_helper'

RSpec.describe FeatureLog, type: :model do
  let!(:student) { FactoryGirl.create(:user, :student) }
  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:master_feature) { FactoryGirl.create(:master_feature) }
  let!(:pvfp) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature,
                       product_version: productVer, is_default: true
                      )
  end
  let!(:course) { FactoryGirl.create(:course, product_version: productVer) }
  let!(:enrolment) { FactoryGirl.create(:enrolment, course: course) }

  let!(:feature_log) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                     acquired: DateTime.now, enrolment: enrolment
                      )
  end
  let!(:master_feature2) { FactoryGirl.create(:master_feature, name: 'GamsatTextbookHardCopyFeature') }
  let!(:pvfp2) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature2,
                       product_version: productVer, qty: 5, is_default: false
                      )
  end
  let!(:feature_log2) do
    FactoryGirl.create(:feature_log,
                       product_version_feature_price: pvfp2, enrolment: enrolment,
                       qty: pvfp2.qty
                      )
  end

  let!(:current_order) do
    FactoryGirl.create(:order, user: student, status: 'ongoing')
  end

  describe '#active?' do
    it 'should retun true for active feature log' do
      feature_log = FactoryGirl.create(:feature_log, acquired: DateTime.now)
      expect(feature_log.active?).to eq(true)
    end

    it 'should retun false for non active feature log' do
      feature_log = FactoryGirl.create(:feature_log, acquired: nil)
      expect(feature_log.active?).to eq(false)
    end
  end

  describe '#assign_essays' do
    let!(:tag1) { FactoryGirl.create :tag, name: 'Gamsat' }
    let!(:student) { FactoryGirl.create :user }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatEssayFeature') }
    let!(:course) { FactoryGirl.create(:course, product_version: productVer) }
    # let!(:enrol) { FactoryGirl.create(:enrolment, user: student, course: course) }
    let!(:pvfp) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature, product_version: productVer, qty: 5)
    end
    let!(:feature_log) do
      FactoryGirl.create(:feature_log,
                         product_version_feature_price: pvfp,
                         acquired: DateTime.now, enrolment: enrolment,
                         qty: pvfp.qty
                        )
    end
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
    let!(:tagging) { FactoryGirl.create(:tagging, tag: tag1, taggable: pvfp) }

    context 'when feature_log qty is nil or 0' do
      before do
        feature_log.qty = 0
      end
      it 'return nil' do
        expect(feature_log.assign_essays(false, productVer.id)).to eq(nil)
      end
    end

    context 'when feature log is active and amount > 0 ' do
      context 'essayList.count==0' do
        it 'return nil' do
          expect(feature_log.assign_essays(false, productVer.id)).to eq(nil)
        end
      end

      context 'essayList.count > 0' do
        let!(:essay) { FactoryGirl.create :essay }
        let!(:tagging2) { FactoryGirl.create :tagging, taggable_type: "Essay", tag_id: tag1.id, taggable_id: essay.id }
        let!(:course) { FactoryGirl.create :course }
        xit 'return nil' do
          pvfp.reload
          enrolment.reload
          expect(feature_log.assign_essays(false, productVer.id)).to eq(essay.essay_responses)
        end
      end
    end
  end

  describe '#product_version' do
    it 'should return product version for feature log' do
      expect(feature_log.product_version).to eq(productVer)
    end
  end

  describe '#deactivate' do
    it 'should delete the purchase item' do
      pi = FactoryGirl.create(:purchase_item, order: current_order,
                                              user: student, purchasable: feature_log2
                             )
      expect(feature_log2.deactivate).to eq(pi)
    end
  end

  describe '#feature_log' do
    it 'should activate the feature log' do
      expect(feature_log2.activate(course)).to eq(true)
    end
  end

  describe '#validate_feature_log' do
    let!(:tag1) { FactoryGirl.create :tag, name: 'Gamsat' }
    let!(:student) { FactoryGirl.create :user }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatEssayFeature') }
    let!(:course) { FactoryGirl.create(:course, product_version: productVer) }
    # let!(:enrol) { FactoryGirl.create(:enrolment, user: student, course: course) }
    let!(:pvfp) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature, product_version: productVer, qty: 3)
    end
    let!(:feature_log) do
      FactoryGirl.create(:feature_log,
                         product_version_feature_price: pvfp,
                         acquired: DateTime.now, enrolment: enrolment,
                         qty: pvfp.qty
                        )
    end
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
    let!(:tagging) { FactoryGirl.create(:tagging, tag: tag1, taggable: pvfp) }

    it 'should create addition essay addons if feature is Essay type' do
      student.update_attribute(:active_course_id, course.id)
      feature_log.validate_feature_log
      essay_feature_logs = student.feature_logs.select { |f| f.master_feature.essay? }
      expect(essay_feature_logs.count).to eq(11)
      expect(essay_feature_logs.collect { |f| f.qty }).to match_array([1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10])
    end
  end
end
