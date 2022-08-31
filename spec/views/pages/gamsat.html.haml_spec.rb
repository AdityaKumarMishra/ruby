require 'rails_helper'

RSpec.describe "pages/gamsat", type: :view do
  before(:each) do
    announcement = Announcement.find_by(name: 'GamsatReady')
    announcement = FactoryGirl.create(:announcement, name: 'GamsatReady') unless announcement.present?
    assign(:announcement, announcement)
    assign(:announcement_url, announcement)
    assign(:gamsat_product_info, {
      'online-basic' => {
        extra_prac_material: false,
        live_component: false,
        targeted_tutor: false,
        price: 495.0
      },
      'online' => {
        extra_prac_material: true,
        live_component: false,
        targeted_tutor: true,
        price: 795.0
      },
      'attendance-basic' => {
        extra_prac_material: false,
        extra_live_component: false,
        live_component: true,
        targeted_tutor: false,
        price: 1045.0
      },
      'attendance' => {
        extra_prac_material: true,
        extra_live_component: false,
        live_component: true,
        targeted_tutor: true,
        price: 1345.0
      },
      'attendance-all' => {
        extra_prac_material: true,
        extra_live_component: true,
        live_component: true,
        targeted_tutor: true,
        price: 1795.0
      }})
  end

  xit "should have gamsat link" do
    controller.request.env['PATH_INFO'] = '/gamsat-preparation-courses'
    render
    expect(rendered).to match "/gamsat-preparation-courses/faq/enrolment-and-payment#group-discount-available"
  end
end
