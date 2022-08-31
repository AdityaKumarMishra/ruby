require "rails_helper"

RSpec.describe FaqPagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/faq_pages").to route_to("faq_pages#index", :type => 'gamsat')
    end

    it "routes to #new" do
      expect(:get => "/admin/faq_pages/new").to route_to("faq_pages#new", :type => 'gamsat')
    end

    it "routes to #show" do
      expect(:get => "/admin/faq_pages/1").to route_to("faq_pages#show", :id => "1", :type => 'gamsat')
    end

    it "routes to #edit" do
      expect(:get => "/admin/faq_pages/1/edit").to route_to("faq_pages#edit", :id => "1", :type => 'gamsat')
    end

    it "routes to #create" do
      expect(:post => "/admin/faq_pages").to route_to("faq_pages#create", :type => 'gamsat')
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/faq_pages/1").to route_to("faq_pages#update", :id => "1", :type => 'gamsat')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/faq_pages/1").to route_to("faq_pages#update", :id => "1", :type => 'gamsat')
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/faq_pages/1").to route_to("faq_pages#destroy", :id => "1", :type => 'gamsat')
    end

  end
end
