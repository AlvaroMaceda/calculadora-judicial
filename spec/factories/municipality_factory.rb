FactoryBot.define do

  sequence :municipality_code do |n|
    '%05i' % n
  end

  factory :municipality do
    code { generate(:municipality_code) }
    name { Faker::Address.city }
    autonomous_community
  end

end