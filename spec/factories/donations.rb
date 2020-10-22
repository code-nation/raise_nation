FactoryBot.define do
  factory :donation do
    workflow
    webhook_data { {} }
  end
end
