require 'rails_helper'

RSpec.describe "autonomous_communities/edit", type: :view do
  before(:each) do
    @autonomous_community = assign(:autonomous_community, AutonomousCommunity.create!(
      :name => "MyString",
      :Country => nil
    ))
  end

  it "renders the edit autonomous_community form" do
    render

    assert_select "form[action=?][method=?]", autonomous_community_path(@autonomous_community), "post" do

      assert_select "input[name=?]", "autonomous_community[name]"

      assert_select "input[name=?]", "autonomous_community[Country_id]"
    end
  end
end
