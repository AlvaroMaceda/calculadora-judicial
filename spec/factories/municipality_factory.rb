FactoryBot.define do

  factory :municipality do
    code { Faker::Alphanumeric.unique.alpha(number:5) }
    name { Faker::Address.city }
    autonomous_community
  end

end