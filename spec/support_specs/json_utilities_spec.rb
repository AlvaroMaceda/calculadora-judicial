require 'json'
include JsonUtilities

describe JsonUtilities do
  
  context 'compares an array', focus:true do
    
    let(:json1) {
      [
        {e11: 1, e12: "2"},
        [1,2,3],
        {
          e21: {
            e211: "e211",
            e212: "e212"
          },
          e22: "e22"
        }
      ]
    }

    it 'when is equal with same order' do
      
      json2 = [
        {e11: 1, e12: "2"},
        [1,2,3],
        {
          e21: {
            e211: "e211",
            e212: "e212"
          },
          e22: "e22"
        }
      ]
      expect(compare_json(json1,json2).result).to be(true)
    end

    it 'fails when is different' do

      json2 = [
        {e11: 1, e12: "2"},
        [1,2,3],
        {
          e21: {
            e211: "THIS IS A DIFFERENT VALUE",
            e212: "e212"
          },
          e22: "e22"
        }
      ]
      
      comparison = compare_json(json1,json2)

      expect(comparison.error_path).to eql('$[2].e21.e211')
      expect(comparison.result).to be(false)
    end

    it 'fails when order different' do

      json2 = [
        {e11: 1, e12: "2"},
        {
          e21: {
            e211: "THIS IS A DIFFERENT VALUE",
            e212: "e212"
          },
          e22: "e22"
        },
        [1,2,3],
      ]
      
      comparison = compare_json(json1,json2)
      
      expect(comparison.error_path).to eql('$[1][0]')
      expect(comparison.result).to be(false)
    end

  end

  context 'compares hashes' do
    

  end

end