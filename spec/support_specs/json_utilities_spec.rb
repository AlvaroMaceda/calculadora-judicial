require 'json'

describe JSON do
  
    context 'compares JSON with arrays as base' do
      
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

        it 'when is equal with the same order' do
            json1 = [1,2,3]
            json2 = [1,2,3]
            expect(JSON.compare(json1,json2).result).to be(true)
        end

        it 'fails when there are elements missing' do
            json1 = [1,2,3]
            json2 = [1,3]
            comparison = JSON.compare(json1,json2)

            expect(comparison.error_path).to eq('$[1]')
            expect(comparison.result).to be(false)
        end

        it 'fails when there are extra elements' do
            json1 = [1,2,3]
            json2 = [1,2,3,4]
            comparison = JSON.compare(json1,json2)

            expect(comparison.error_path).to eq('$')
            expect(comparison.result).to be(false)
        end        

        it 'when is equal with same order with subkeys' do
            
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
            expect(JSON.compare(json1,json2).result).to be(true)
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
            
            comparison = JSON.compare(json1,json2)

            expect(comparison.error_path).to eql('$[2].e21.e211')
            expect(comparison.result).to be(false)
        end

      it 'is equal when order differs' do

            json2 = [
                {e11: 1, e12: "2"},
                {
                    e21: {
                        e211: "e211",
                        e212: "e212"
                    },
                    e22: "e22"
                },
                [1,2,3],
            ]
            
            comparison = JSON.compare(json1,json2)
            
            expect(comparison.result).to be(true)
        end

    end

    context 'compares JSON with hashes as base' do

        let(:json1) {
            {
                e1: {e11: 1, e12: "2"},
                e2: [1,2,3],
                e3: {
                        e31: {
                            e311: "e311",
                            e312: "e312"
                        },
                    e32: "e22"
                }
            }
        }

        it 'when is equal with same order' do
        
            json2 = {
                e1: {e11: 1, e12: "2"},
                e2: [1,2,3],
                e3: {
                        e31: {
                            e311: "e311",
                            e312: "e312"
                        },
                    e32: "e22"
                }
            }
            expect(JSON.compare(json1,json2).result).to be(true)
        end

        it 'when is equal with different order' do
        
            json2 = {
                e3: {
                    e32: "e22",
                    e31: {
                        e312: "e312",
                        e311: "e311",
                    },
                },
                e2: [1,2,3],
                e1: {e11: 1, e12: "2"},
            }
            expect(JSON.compare(json1,json2).result).to be(true)
        end        

        it 'fails when is different' do

            json2 = {
                e3: {
                    e32: "e22",
                    e31: {
                        e312: "e312",
                        e311: "THIS IS A DIFFERENT VALUE, TOO",
                    },
                },
                e2: "THIS IS THE DIFFERENCE IT WILL FIND",
                e1: {e11: 1, e12: "2"},
            }
          
            comparison = JSON.compare(json1,json2)
            
            expect(comparison.error_path).to eql('$.e2')
            expect(comparison.result).to be(false)
        end

    end

end