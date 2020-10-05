FactoryBot.define do
  factory :workflow do
    name { Faker::Company.name }
    source { nil }
    target { nil }
    donor_tag { [Faker::Lorem.word] }
    recurring_donor_tag { [Faker::Lorem.word] }
    is_active { false }
    account { nil }
  end
end
