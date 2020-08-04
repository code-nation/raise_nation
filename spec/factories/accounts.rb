FactoryBot.define do
  factory :account do
    organisation_name { Faker::Company.name }
    owner { build(:user) }
  end

  trait :with_campaigns do
    after(:build) do |account|
      account.raisely_campaigns << FactoryBot.build_list(:raisely_campaign, rand(1..3))
    end
  end

  trait :with_nations do
    after(:build) do |account|
      account.nations << FactoryBot.build_list(:nation, rand(1..3))
    end
  end

  trait :with_nations_and_campaigns do
    after(:build) do |account|
      account.nations << FactoryBot.build_list(:nation, rand(1..3))
      account.raisely_campaigns << FactoryBot.build_list(:raisely_campaign, rand(1..3))
    end
  end
end
