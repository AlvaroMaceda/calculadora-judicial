require 'rails_helper'

describe Municipality, type: :model do
  
  let(:municipality) { create(:municipality) }

  it "has a valid factory" do
    expect(municipality).to be_valid
  end

  it "is invalid without a name" do
    noname_municipality = build(:municipality, name: nil)
    expect(noname_municipality).not_to be_valid
  end

  it "is invalid without a code" do
    nocode_municipality = build(:municipality, code: nil)
    expect(nocode_municipality).not_to be_valid
  end

  it "has a unique code for its autonomous community " do
    repeated_municipality = build(:municipality, code: municipality.code, autonomous_community: municipality.autonomous_community)
    expect(repeated_municipality).not_to be_valid    
  end

  it "can repeat code for another autonomous community " do
    another_ac = create(:autonomous_community)
    repeated_municipality = create(:municipality, code: municipality.code, autonomous_community: another_ac)
    expect(repeated_municipality).to be_valid    
  end

  it "belongs to an autonomous community" do
    expect(municipality.autonomous_community).not_to be nil
  end

end