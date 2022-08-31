require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::TestHelpers

  describe "GET posts" do
    login_student
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe 'GET post' do
    subject { response }
    let(:post) { FactoryGirl.create :post }

    xit { expect { get :show, id: post.id }.not_to raise_error }
  end
end
