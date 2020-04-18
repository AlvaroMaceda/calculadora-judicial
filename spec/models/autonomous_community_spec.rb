require 'rails_helper'

describe AutonomousCommunity, type: :model do

  let(:ac) { create(:autonomous_community) }

  it "has a valid factory" do
    expect(ac).to be_valid
  end

  it "is invalid without a name" do
    ac = build(:autonomous_community, name: nil)
    expect(ac).not_to be_valid
  end

  it "has a unique name" do
    repeated_ac = build(:autonomous_community, name: ac.name)
    expect(repeated_ac).not_to be_valid
  end

  it "belongs to a country" do
    expect(ac.country).not_to be nil
  end

  it "has multiple municipalities" do
    cuenca = create(:cuenca)
    expect(cuenca.municipalities.length).to be > 0
  end

end
