FactoryBot.define do
  factory :donor do
    donor_type { 1 }
    donor_tag { "MyString" }
    recurring_donor_tag { "MyString" }
    donor_data { "" }
  end
end
