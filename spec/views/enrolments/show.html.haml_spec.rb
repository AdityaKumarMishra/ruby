require 'rails_helper'

RSpec.describe 'enrolments/show', type: :view do
  before(:each) do
    @student = assign(:student, FactoryGirl.create(:user))
    @enrolment = assign(:enrolment, FactoryGirl.create(:enrolment))
    @order = assign(:order, FactoryGirl.create(:order, user: @student))
    @productVer = assign(:productVer, FactoryGirl.create(:product_version))
    @master_feature = assign(:master_feature, FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams'))
    @pvfp = assign(:pvfp, FactoryGirl.create(:product_version_feature_price,
                       master_feature: @master_feature,
                       product_version: @productVer, is_default: true
                      ))
    @feature_log = assign(:feature_log, FactoryGirl.create(:feature_log, product_version_feature_price: @pvfp,
                                     acquired: DateTime.now, enrolment: @enrolment
                      ))
    @purchase_item = assign(:purchase_item, FactoryGirl.create(:purchase_item, user: @student, order: @order, purchasable: @enrolment))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to have_content(@enrolment.course.name)

    expect(rendered).to have_content(@student.username)
  end
end
