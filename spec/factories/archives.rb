FactoryBot.define do
  factory :archive do
    folder { FactoryBot.create(:folder)}
    name { FFaker::Lorem.word }
    description { FFaker::Lorem.sentence }
    sequence(:order) { |n| n }
    file do
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.zip'), 'application/zip')
    end

    trait :image do
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpg'), 'image/jpeg')
      end
    end

    trait :pdf do
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.pdf'), 'application/pdf')
      end
    end
  end
end
