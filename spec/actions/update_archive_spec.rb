require 'rails_helper'

RSpec.describe UpdateArchive do
  let(:folder) { FactoryBot.create(:folder) }
  let(:archive) { FactoryBot.create(:archive, :csv, folder:) }
  let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf') }

  describe 'Happy path' do
    it 'User update archive with no folder' do
      expect(archive.name).to_not eq 'New name'
      expect(archive.description).to_not eq 'Description'
      expect(archive.filename).to_not eq 'test.pdf'

      action = described_class.new(archive_id: archive.id, name: "New name", description: 'Description', file:)

      expect(action).to be_valid
      expect(action.save).to be true

      updated_archive = action.archive

      expect(updated_archive.id).to eql(archive.id)
      expect(updated_archive.name).to eq 'New name'
      expect(updated_archive.description).to eq 'Description'
      expect(updated_archive.content_type).to eq 'pdf'
      expect(updated_archive.file).to be_attached
      expect(updated_archive.size).to be_present
      expect(updated_archive.folder).to be_nil
    end

    it 'User updates archive with folder' do
      another_folder = FactoryBot.create(:folder)

      expect(archive.name).to_not eq 'New name'
      expect(archive.description).to_not eq 'Description'
      expect(archive.filename).to_not eq 'test.pdf'
      expect(archive.folder).to_not eq another_folder

      action = described_class.new(archive_id: archive.id, description: 'Description', folder_id: another_folder.id, file:)

      expect(action).to be_valid
      expect(action.save).to be true

      updated_archive = action.archive

      expect(updated_archive.id).to eql(archive.id)
      expect(updated_archive.name).to_not eq archive.name
      expect(updated_archive.description).to eq 'Description'
      expect(updated_archive.content_type).to eq 'pdf'
      expect(updated_archive.file).to be_attached
      expect(updated_archive.size).to be_present
      expect(updated_archive.folder).to eq another_folder
    end
  end

  describe 'Validations' do
    it 'If folder is not found, it should return an error' do
      action = described_class.new(archive_id: archive.id, description: 'Description', folder_id: 9999, file:)

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Pasta não encontrada')
    end

    it 'When passed files is nil' do
      action = described_class.new(archive_id: archive.id, description: 'Description')

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('File não pode ficar em branco')
    end
  end
end
