require 'rails_helper'

describe Municipality, type: :model do
  
  it "has a valid factory" do
    municipality = create(:municipality)
    expect(municipality).to be_valid
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
    municipality = create(:municipality)
    repeated_municipality = build(:municipality, code: municipality.code)
    expect(repeated_municipality).not_to be_valid    
  end


end