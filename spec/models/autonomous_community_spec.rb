require 'rails_helper'

describe AutonomousCommunity, type: :model do

  before(:all) do
    @ac = create(:autonomous_community) 
  end

  after(:all) do
    Faker::UniqueGenerator.clear # Clears used values for all generators
  end

  it "has a valid factory" do
    expect(@ac).to be_valid
  end

  it "is invalid without a name" do
    ac = build(:autonomous_community, name: nil)
    expect(ac).not_to be_valid
  end

  it "has a unique name" do
    repeated_ac = build(:autonomous_community, name: @ac.name)
    expect(repeated_ac).not_to be_valid
  end

  it "belongs to a country" do
    expect(@ac.country).not_to be nil
  end

  xit "has multiple municipalities" do
    cuenca = create(:cuenca)
    expect(spain.autonomous_communities.length).to be > 0
  end

end
