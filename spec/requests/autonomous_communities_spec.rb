require 'rails_helper'

RSpec.describe "AutonomousCommunities", type: :request do
  describe "GET /autonomous_communities" do
    it "works! (now write some real specs)" do
      get autonomous_communities_path
      expect(response).to have_http_status(200)
    end
  end
end
