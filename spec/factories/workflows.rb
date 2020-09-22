FactoryBot.define do
  factory :workflow do
    name { Faker::Company.name }
    source { build(:nation) }
    target { build(:raisely_campaign) }
    donor_tags { [Faker::Lorem.word] }
    recurring_donor_tags { [Faker::Lorem.word] }
    is_active { false }
    account { build(:account) }
  end
end
