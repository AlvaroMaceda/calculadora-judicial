require 'rails_helper'

RSpec.describe AutonomousCommunity, type: :model do

  it "has a valid factory" do
    autonomous_community = create(:autonomous_community)
    expect(autonomous_community).to be_valid
  end

  it "is invalid without a name" do
    autonomous_community = build(:autonomous_community, name: nil)
    expect(autonomous_community).not_to be_valid
  end

end
