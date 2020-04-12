require 'rails_helper'

describe Country, type: :model do

  it "has a valid factory" do
    country = create(:country)
    expect(country).to be_valid
  end

  it "is invalid without a name" do
    country = build(:country, name: nil)
    expect(country).not_to be_valid
  end

  it "has multiple autonomous communities" do
    spain = create(:spain)
    expect(spain.autonomous_communities.length).to be > 0
  end

end
