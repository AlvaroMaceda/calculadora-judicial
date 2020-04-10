FactoryBot.define do

  factory :country do
    name { Faker::Address.unique.country }

    factory :spain do

      name {'Spain'}
  
      after(:create) do |country, evaluator|
        create_list(:autonomous_community, 17, country: country)
      end
  
    end

  end
  
end

FactoryBot.define do

  # post factory with a `belongs_to` association for the user
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  # user factory without associated posts
  factory :user do
    name { "John Doe" }

    # user_with_posts will create post data after the user has been created
    factory :user_with_posts do
      # posts_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        posts_count { 5 }
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end
end