require 'rails_helper'

RSpec.describe 'dashboard/purchase_summary', type: :view do
  before(:each) do
    @student = FactoryGirl.create(:user)
    @enrolment1 = FactoryGirl.create(:enrolment)
    @enrolment2 = FactoryGirl.create(:enrolment)
    assign(:student, @student)
    assign(:enrolments, [@enrolment1, @enrolment2])
    @purchased_enrolments = @student.enrolments.includes(:course, [purchase_item: [order: [:generated_promo]]])
    @purchased_addons = @student.enrolments.includes(feature_enrolments: [featurettes: [purchase_item: [:order]]]).map(&:feature_enrolments).flatten.compact.select { |f| f.active == true && f.purchase_items.first.present? }
  end

  it 'renders purchase_summary' do
    expect { render }.not_to raise_error
  end
end
