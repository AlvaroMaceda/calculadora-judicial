require 'rails_helper'


describe Territory, type: :model do
  
    let(:territory) { create(:territory) }

    it "has a valid factory" do
        expect(territory).to be_valid
    end

    it "is invalid without a name" do
        noname_territory = build(:territory, name: nil)
        expect(noname_territory).not_to be_valid
    end

    it "is invalid without a code" do
        nocode_territory = build(:territory, code: nil)
        expect(nocode_territory).not_to be_valid
    end

    it "has a unique code" do
        repeated_territory = build(:territory, code: territory.code)
        expect(repeated_territory).not_to be_valid 
    end

    it "can belong to annother territory" do
        parent_territory = create(:territory)
        child_territory = create(:territory, parent: parent_territory)

        expect(child_territory).to be_valid 
    end

    it "can have multiple child territories" do
        parent_territory = create(:territory)
        child_territory_1 = create(:territory, parent: parent_territory)
        child_territory_2 = create(:territory, parent: parent_territory)

        expected_childs = [
            child_territory_1, child_territory_2
        ]

        expect(parent_territory.territories).to match(expected_childs) 
    end

    context 'holidays' do
        
        it 'can have multiple holidays' do
            
        end

    end
  
    context 'returns its holidays between two dates in order' do
    end

end