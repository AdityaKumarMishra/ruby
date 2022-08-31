require 'rails_helper'

RSpec.describe 'exercises/edit', type: :view do
  before(:each) do
    @exercise = assign(:exercise, FactoryGirl.create(:exercise))
    @user = FactoryGirl.create(:user)
    @available_tags = [FactoryGirl.create(:tag)]
    @statistics = Tag.mcq_statistics(@user, @available_tags)
    sign_in @user
    @productVer = FactoryGirl.create(:product_version)
    @course = FactoryGirl.create(:course, product_version_id: @productVer.id)
    @order = FactoryGirl.create(:order, status: :paid, user: @user)
    @enrolment = FactoryGirl.create(:enrolment)
    @paid_purchase_item = FactoryGirl.create(:purchase_item, user: @user, order: @order, purchasable: @enrolment)
    allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(@user, Tag))
  end

  it 'renders the edit exercise form' do
    @user.update_attribute(:active_course_id, @course.id)
    render

    assert_select 'form[action=?][method=?]', exercise_path(@exercise), 'post' do
      assert_select 'select#exercise_difficulty[name=?]', 'exercise[difficulty]'

      assert_select 'input#exercise_amount[name=?]', 'exercise[amount]'
    end
  end
end
