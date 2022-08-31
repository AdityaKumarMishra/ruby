require "rails_helper"

RSpec.describe TransferTransactionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/transfer_transactions").to route_to("transfer_transactions#index")
    end

    it "routes to #new" do
      expect(:get => "/transfer_transactions/new").to route_to("transfer_transactions#new")
    end

    it "routes to #show" do
      expect(:get => "/transfer_transactions/1").to route_to("transfer_transactions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/transfer_transactions/1/edit").to route_to("transfer_transactions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/transfer_transactions").to route_to("transfer_transactions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/transfer_transactions/1").to route_to("transfer_transactions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/transfer_transactions/1").to route_to("transfer_transactions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/transfer_transactions/1").to route_to("transfer_transactions#destroy", :id => "1")
    end

  end
end
