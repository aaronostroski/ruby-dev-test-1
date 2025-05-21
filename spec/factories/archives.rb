FactoryBot.define do
  factory :archive do
    folder { FactoryBot.create(:folder)}
    name { FFaker::Lorem.word }
    description { FFaker::Lorem.sentence }
    file do
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.zip'), 'application/zip')
    end

    trait :image do
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpeg'), 'image/jpeg')
      end
    end

    trait :pdf do
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.pdf'), 'application/pdf')
      end
    end

    trait :csv do
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.csv'), 'text/csv')
      end
    end

    trait :video do
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.mp4'), 'video/mp4')
      end
    end
  end
end
