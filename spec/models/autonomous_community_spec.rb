require 'rails_helper'

describe AutonomousCommunity, type: :model do

  after(:all) do
    Faker::UniqueGenerator.clear # Clears used values for all generators
  end

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
