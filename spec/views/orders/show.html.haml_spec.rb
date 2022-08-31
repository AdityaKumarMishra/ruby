require 'rails_helper'

RSpec.describe 'orders/show.html.haml', type: :view do
  login_student

  context 'no promo for order' do
    it 'renders without error' do
      @order = FactoryGirl.create :order
      @user = @order.user
      render
    end
  end
end
