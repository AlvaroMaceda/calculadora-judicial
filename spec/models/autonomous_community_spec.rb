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

  it "is invalid with a blank name" do
    ac = build(:autonomous_community, name: '')
    expect(ac).not_to be_valid
  end

  it "is invalid without a code" do
    ac = build(:autonomous_community, code: nil)
    expect(ac).not_to be_valid
  end

  it "belongs to a country" do
    expect(ac.country).not_to be nil
  end

  it "has a unique code for a country" do
    repeated_ac = build(:autonomous_community, code: ac.code, country: ac.country)
    expect(repeated_ac).not_to be_valid
  end

  it "can repeat code for another country" do
    another_country = create(:country)
    repeated_ac = build(:autonomous_community, name: ac.name, country: another_country)
    expect(repeated_ac).to be_valid
  end

  it "has multiple municipalities" do
    cuenca = create(:cuenca)
    expect(cuenca.municipalities.length).to be > 0
  end

end
