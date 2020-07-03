FactoryBot.define do
  factory :account do
    organisation_name { Faker::Company.name }
    owner { create(:user) }
  end
end
