require 'rails_helper'

RSpec.describe "autonomous_communities/index", type: :view do
  before(:each) do
    assign(:autonomous_communities, [
      AutonomousCommunity.create!(
        :name => "Name",
        :Country => nil
      ),
      AutonomousCommunity.create!(
        :name => "Name",
        :Country => nil
      )
    ])
  end

  it "renders a list of autonomous_communities" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
