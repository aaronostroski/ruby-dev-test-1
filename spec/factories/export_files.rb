FactoryBot.define do
  factory :export_file do
    folder { FactoryBot.create(:folder) }
    filename { "export-#{FFaker::Book.title.parameterize}.zip" }
    size { 10.0 }

    trait :started do
      started_at { Time.current }
    end

    trait :finished do
      started
      finished_at { Time.current }
      file do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.pdf'), 'application/pdf')
      end
    end

    trait :error do
      started
      error_at { Time.current }
      error_message { "Error Export" }
    end
  end
end
