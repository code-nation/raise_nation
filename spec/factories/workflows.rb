FactoryBot.define do
  factory :workflow do
    name { "MyString" }
    source { nil }
    target { nil }
    donor_tag { "MyString" }
    recurring_donor_tag { "MyString" }
    is_active { false }
    account { nil }
  end
end
