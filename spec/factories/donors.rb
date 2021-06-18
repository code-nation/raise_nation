FactoryBot.define do
  factory :donor do
    donor_type { 1 }
    donor_tags { Faker::Lorem.words }
    recurring_donor_tags { Faker::Lorem.words }
    donor_data { '' }
  end
end
