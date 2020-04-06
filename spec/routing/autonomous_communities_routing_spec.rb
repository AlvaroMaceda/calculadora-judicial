require "rails_helper"

RSpec.describe AutonomousCommunitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/autonomous_communities").to route_to("autonomous_communities#index")
    end

    it "routes to #new" do
      expect(:get => "/autonomous_communities/new").to route_to("autonomous_communities#new")
    end

    it "routes to #show" do
      expect(:get => "/autonomous_communities/1").to route_to("autonomous_communities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/autonomous_communities/1/edit").to route_to("autonomous_communities#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/autonomous_communities").to route_to("autonomous_communities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/autonomous_communities/1").to route_to("autonomous_communities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/autonomous_communities/1").to route_to("autonomous_communities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/autonomous_communities/1").to route_to("autonomous_communities#destroy", :id => "1")
    end
  end
end
