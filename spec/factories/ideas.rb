FactoryBot.define do
  factory :idea do
    body { Faker::Name.last_name }
    association :category
  end
end
