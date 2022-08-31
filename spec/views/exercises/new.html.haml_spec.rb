require 'rails_helper'

RSpec.describe 'exercises/new', type: :view do
  login_student
  before(:each) do
    assign(:exercise, Exercise.new(user: FactoryGirl.create(:user)))
    allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(FactoryGirl.create(:user), Tag))
    @available_tags = [FactoryGirl.create(:tag)]
    @statistics = Tag.mcq_statistics(@user, @available_tags)
    sign_in :user

  end

  xit 'renders new exercise form' do
    render

    assert_select 'form[action=?][method=?]', exercises_path, 'post' do
      assert_select 'select#exercise_difficulty[name=?]', 'exercise[difficulty]'

      assert_select 'input#exercise_amount[name=?]', 'exercise[amount]'
    end
  end
end
