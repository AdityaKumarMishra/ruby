require 'rails_helper'

RSpec.describe 'user_enrolments/index', type: :view do
  before(:each) do
    @student = FactoryGirl.create(:user)
    @order = FactoryGirl.create(:order, status: :paid, user: @student)

    @productVer = assign(:productVer, FactoryGirl.create(:product_version))
    @master_feature = assign(:master_feature, FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams'))
    @enrolment1 = FactoryGirl.create(:enrolment)

    @pvfp1 = FactoryGirl.create(:product_version_feature_price,
                       master_feature: @master_feature,
                       product_version: @productVer, is_default: true
                      )
    @feature_log1 = FactoryGirl.create(:feature_log, product_version_feature_price: @pvfp1,
                                     acquired: DateTime.now, enrolment: @enrolment1
                      )
    @paid_purchase_item1 = FactoryGirl.create(:purchase_item, user: @student, order: @order, purchasable: @enrolment1)

    @enrolment2 = FactoryGirl.create(:enrolment)
    @pvfp2 = FactoryGirl.create(:product_version_feature_price,
                       master_feature: @master_feature,
                       product_version: @productVer, is_default: true
                      )
    @feature_log1 = FactoryGirl.create(:feature_log, product_version_feature_price: @pvfp2,
                                     acquired: DateTime.now, enrolment: @enrolment2
                      )
    @paid_purchase_item1 = FactoryGirl.create(:purchase_item, user: @student, order: @order, purchasable: @enrolment2)

    assign(:student, @student)
    assign(:enrolments, [@enrolment1, @enrolment2])
  end

  it 'renders a list of courses' do
    @enrolment1.reload
    @enrolment2.reload
    render
    expect(rendered).to have_content(@enrolment1.user.email)
    expect(rendered).to have_content(@enrolment2.user.email)
    expect(rendered).to have_content(@enrolment1.course.name)
    expect(rendered).to have_content(@enrolment2.course.name)
  end
end
