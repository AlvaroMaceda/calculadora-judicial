require 'rails_helper'

describe Municipality, type: :model do
  
  before(:all) do
    @municipality = create(:municipality)
  end

  it "has a valid factory" do
    expect(@municipality).to be_valid
  end

  it "is invalid without a name" do
    municipality = build(:municipality, name: nil)
    expect(municipality).not_to be_valid
  end

  it "is invalid without a code" do
    municipality = build(:municipality, code: nil)
    expect(municipality).not_to be_valid
  end

  it "has a unique code" do
    repeated_municipality = build(:municipality, code: @municipality.code)
    expect(repeated_municipality).not_to be_valid    
  end

  it "belongs to an autonomous community" do
    expect(@municipality.autonomous_community).not_to be nil
  end

end