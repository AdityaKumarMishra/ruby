require 'rails_helper'

RSpec.describe "contact/index", type: :view do
  let(:user) { FactoryGirl.create(:user) }
  FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:gamsat], code: 'about-gradready')
  FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:gamsat], code: 'preparing-gamsat')
  FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:gamsat], code: 'enrolment-payment')
  before(:each) do
    sign_in user
    assign(:contact_form, FactoryGirl.build(:contact_form))
    assign(:product_line, 'gamsat')
  end

  it 'should show the contact information' do
    controller.request.env['PATH_INFO'] = '/gamsat/contact'
    render
    expect(rendered).to match /Hemant/
    expect(rendered).to match /Peitong/
  end
end
