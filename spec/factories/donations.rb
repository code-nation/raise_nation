FactoryBot.define do
  factory :donation do
    workflow { "" }
    webhook_data { "" }
    donation_type { 1 }
  end
end
