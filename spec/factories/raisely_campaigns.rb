FactoryBot.define do
  factory :raisely_campaign do
    name { Faker::Company.name }
    campaign_uuid { SecureRandom.uuid }
    api_key { SecureRandom.uuid }
    account
  end
end
