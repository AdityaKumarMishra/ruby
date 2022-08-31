require 'rails_helper'

RSpec.describe 'layouts/_footer.html.haml', type: :view do
  include Devise::TestHelpers
  before { allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(nil, Tag)) }

  describe 'google analytics' do
    context 'production' do
      before { Rails.env.stub(production?: true) }

      it 'should render' do
        render 'layouts/footer', product_line: 'gamsat'
      end
    end

    context 'not production' do
      before { Rails.env.stub(production?: false) }

      it 'should not render' do
        render 'layouts/footer', product_line: 'gamsat'
      end
    end
  end
end
