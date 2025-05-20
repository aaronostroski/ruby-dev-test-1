FactoryBot.define do
  factory :folder do
    name { FFaker::Lorem.word }
    description { FFaker::Lorem.sentence }
    sequence(:order) { |n| n }
  end
end
