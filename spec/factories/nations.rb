FactoryBot.define do
  factory :nation do
    slug { Faker::Company.name.downcase.underscore }
    token { SecureRandom.uuid }
    account
  end
end
