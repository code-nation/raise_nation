FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    preferred_name { Faker::Name.name }
    password { 'P@ssw0rd!' }
  end

  trait :with_accounts do
    after(:build) do |user|
      user.accounts << FactoryBot.build_list(:account, rand(1..3))
    end
  end

  trait :with_all do
    after(:build) do |user|
      user.accounts << FactoryBot.build_list(:account, rand(1..3), :with_nations_and_campaigns)
    end
  end
end
