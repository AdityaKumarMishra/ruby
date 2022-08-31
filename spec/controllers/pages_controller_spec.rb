require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  login_student

  describe "show_course_recommender" do
    it "renders course recommender template" do
      post :show_course_recommender, format: :js
      expect(response).to be_success
    end
  end
  describe '#main' do
    xit 'show announcement of type homepage' do
      @announcement = Announcement.create!( name: 'Homepage', description: 'test', url: 'www.google.com', category: 'Homepage')
      get :main
      expect(assigns(:announcement)).to eq(@announcement)
      expect(assigns(:announcement_url)).to eq(@announcement.url)
    end
  end
end
