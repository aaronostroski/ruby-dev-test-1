require 'rails_helper'

RSpec.describe CreateNewArchives do
  let(:folder) { FactoryBot.create(:folder) }
  let(:files) { [ Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf') ] }

  describe 'Happy path' do
    it 'User creates news archives with no folder' do
      action = described_class.new(description: 'Description', files:)

      expect(action).to be_valid
      expect(action.save).to be true

      archive = action.archives.first

      expect(archive).to be_persisted
      expect(archive.name).to eq archive.filename
      expect(archive.description).to eq 'Description'
      expect(archive.content_type).to eq 'pdf'
      expect(archive.file).to be_attached
      expect(archive.size).to be_present
      expect(archive.folder).to be_nil
    end

    it 'User creates new folder with folder' do
      folder = FactoryBot.create(:folder)
      action = described_class.new(description: 'Description', folder_id: folder.id, files:)

      expect(action).to be_valid
      expect(action.save).to be true

      archive = action.archives.first

      expect(archive).to be_persisted
      expect(archive.name).to eq archive.filename
      expect(archive.description).to eq 'Description'
      expect(archive.content_type).to eq 'pdf'
      expect(archive.file).to be_attached
      expect(archive.size).to be_present
      expect(archive.folder).to eq folder
    end

    it 'User can pass multiples files' do
      files = [
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf')
      ]
      action = described_class.new(description: 'Description', files:)

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.archives.count).to eq 2

      action.archives.each_with_index do |archive, index|
        expect(archive).to be_persisted
        expect(archive.name).to eq archive.filename
        expect(archive.description).to eq 'Description'
        expect(archive.content_type).to eq 'pdf'
        expect(archive.file).to be_attached
        expect(archive.size).to be_present
        expect(archive.folder).to be_nil
      end
    end
  end

  describe 'Validations' do
    it 'If folder is not found, it should return an error' do
      action = described_class.new(description: 'Description', folder_id: 9999, files:)

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Pasta não encontrada')
    end

    it 'When passed files is an empty array' do
      action = described_class.new(description: 'Description', files: [])

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Arquivos não encontrados')
    end

    it 'When passed files is nil' do
      action = described_class.new(description: 'Description')

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Arquivos não encontrados')
    end
  end
end
