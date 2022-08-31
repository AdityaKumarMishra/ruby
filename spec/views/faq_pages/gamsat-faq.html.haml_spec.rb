require 'rails_helper'

RSpec.describe 'faq_pages/gamsat-faq', type: :view do
  before do
    @faq_type = 'gamsat'
    @faq_topic = FaqTopic.for_type(@faq_type)
    @icons = {
      'understanding-gamsat' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_understanding.png',
      'preparing-gamsat' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_preparing.png',
      'about-gradready' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_about.png',
      'enrolment-payment' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_enrolment-payment.png',
      'non-science-background' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_non-science.jpg',
      'postgraduate-medical-school-admissions' => 'https://gradready.s3.ap-southeast-2.amazonaws.com/static/icons/faq_gamstat_admission.png'
    }
    FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:vce], code: 'understanding-gamsat', title: 'Understanding the GAMSAT', slug: 'understanding-the-gamsat')
    FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:vce], code: 'preparing-gamsat', title: 'Preparing for the GAMSAT', slug: 'preparing-for-the-gamsat')
    FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:vce], code: 'about-gradready', title: 'About GradReady', slug: 'about-gradready')
    FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:vce], code: 'enrolment-payment', title: 'Enrolment and Payment', slug: 'enrolment-and-payment')
    FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:vce], code: 'non-science-background', title: 'For students from a non-science background', slug: 'for-students-from-a-non-science-background')
    FactoryGirl.create(:faq_topic, faq_type: FaqTopic.faq_types[:vce], code: 'postgraduate-medical-school-admissions', title: 'Postgraduate Medical School Admissions', slug: 'postgraduate-medical-school-admissions')
  end
  xit 'It should contain changed heading' do
    controller.request.env['PATH_INFO'] = '/gamsat/faq'
    render
    expect(rendered).to have_content('GAMSAT® Courses | FAQ')
  end
end
