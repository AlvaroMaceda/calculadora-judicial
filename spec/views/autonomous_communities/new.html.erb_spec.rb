require 'rails_helper'

RSpec.describe "autonomous_communities/new", type: :view do
  before(:each) do
    assign(:autonomous_community, AutonomousCommunity.new(
      :name => "MyString",
      :Country => nil
    ))
  end

  it "renders new autonomous_community form" do
    render

    assert_select "form[action=?][method=?]", autonomous_communities_path, "post" do

      assert_select "input[name=?]", "autonomous_community[name]"

      assert_select "input[name=?]", "autonomous_community[Country_id]"
    end
  end
end
