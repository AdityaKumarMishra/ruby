require 'rails_helper'

RSpec.describe 'courses/show', type: :view do
  before(:each) do
    @staff_profile = FactoryGirl.create(:staff_profile)
    @course = assign(:course, Course.create!(
                                name: 'Name',
                                class_size: 5,
                                product_version_id: 3,
                                trial_enabled: true,
                                trial_period_days: 3,
                                enrolment_end_date: Time.zone.now,
                                essay_exp_start_date: Date.today.beginning_of_year,
                                expiry_date: Time.zone.now,
                                staff_profile_ids: @staff_profile.id
    ))
    @user1 = FactoryGirl.create(:user, :student)
    @user2 = FactoryGirl.create(:user, :student)
    @order1 = FactoryGirl.create(:order, status: :paid, user: @user1)
    @order2 = FactoryGirl.create(:order, status: :paid, user: @user2)
    @enrolment1 = FactoryGirl.create(:enrolment, course: @course)
    @enrolment2 = FactoryGirl.create(:enrolment, course: @course)
    @paid_purchase_item1 = FactoryGirl.create(:purchase_item, user: @user1, order: @order1, purchasable: @enrolment1)
    @paid_purchase_item2 = FactoryGirl.create(:purchase_item, user: @user1, order: @order2, purchasable: @enrolment2)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to have_selector(:link_or_button, 'Download CSV')
  end
end
