require 'rails_helper'

RSpec.describe AutonomousCommunity, type: :model do

  it "has a valid factory" do
    ac = create(:autonomous_community)
    expect(ac).to be_valid
  end

  it "is invalid without a name" do
    ac = build(:autonomous_community, name: nil)
    expect(ac).not_to be_valid
  end

  it "has a unique name" do
    ac = create(:autonomous_community)
    repeated_ac = build(:autonomous_community, name: ac.name)
    expect(repeated_ac).not_to be_valid
  end

end
