FactoryBot.define do
  factory :archive do
    folder { FactoryBot.create(:folder)}
    name { FFaker::Lorem.word }
    description { FFaker::Lorem.sentence }
    sequence(:order) { |n| n }
    file do
      Rack::Test::UploadedFile.new(Rails.root.join('spec/support/test.zip'), 'application/zip')
    end

    trait :image do
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/support/test.jpg'), 'image/jpeg')
      end
    end

    trait :pdf do
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/support/test.pdf'), 'application/pdf')
      end
    end
  end
end
