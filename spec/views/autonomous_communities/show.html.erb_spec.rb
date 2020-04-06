require 'rails_helper'

RSpec.describe "autonomous_communities/show", type: :view do
  before(:each) do
    @autonomous_community = assign(:autonomous_community, AutonomousCommunity.create!(
      :name => "Name",
      :Country => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
