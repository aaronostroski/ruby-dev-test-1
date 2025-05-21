require 'rails_helper'

RSpec.describe Archive, type: :model do
  it 'Factory is valid' do
    expect(FactoryBot.build(:archive)).to be_valid
  end
  
  it 'Archive is a image' do
    archive_image = FactoryBot.create(:archive, :image)
    expect(archive_image.image?).to be true
  end

  it 'Archive is a pdf' do
    archive_pdf = FactoryBot.create(:archive, :pdf)    
    expect(archive_pdf.pdf?).to be true
  end

  it 'Archive is a csv' do
    archive_csv = FactoryBot.create(:archive, :csv)
    expect(archive_csv.csv_or_xlsx?).to be true
  end

  it 'Archive is a zip' do
    archive_zip = FactoryBot.create(:archive)
    expect(archive_zip.zip?).to be true
  end

  it 'Archive is a video' do
    archive_video = FactoryBot.create(:archive, :video)
    expect(archive_video.video?).to be true
  end    

  it 'Only should set size and type when file changes' do
    archive = FactoryBot.create(:archive, :csv)
    size_before = archive.size
    type_before = archive.content_type
    expect(size_before).to be_present

    archive.file.attach(Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf'))
    new_size = archive.size
    new_type = archive.content_type
    expect(new_size).to_not eq size_before
    expect(new_type).to_not eq type_before

    archive.update(name: 'New name', description: 'Description')
    expect(archive.size).to eq new_size
    expect(archive.content_type).to eq new_type
  end

  describe 'Validations' do
    it 'File should be present' do
      folder = FactoryBot.create(:folder)
      archive = FactoryBot.build(:archive, folder:, file: nil)

      expect(archive).to_not be_valid
      expect(archive.errors[:file]).to include('não pode ficar em branco')
    end
  end
end