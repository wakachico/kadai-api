FactoryBot.define do
  factory :category do
    name { Faker::Name.last_name }
  end
end
