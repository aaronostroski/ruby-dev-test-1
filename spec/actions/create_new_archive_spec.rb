require 'rails_helper'

RSpec.describe CreateNewArchive do
  let(:folder) { FactoryBot.create(:folder) }
  let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf') }

  describe 'Happy path' do
    it 'User creates new archive with no parent folder' do
      action = described_class.new(name: 'Archive', description: 'Description', order: 1, file:)

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.archive).to be_persisted
      expect(action.archive.name).to eq 'Archive'
      expect(action.archive.description).to eq 'Description'
      expect(action.archive.order).to eq 1
      expect(action.archive.file).to be_attached
      expect(action.archive.folder).to be_nil
    end

    it 'User creates new folder with parent folder' do
      folder = FactoryBot.create(:folder)
      action = described_class.new(name: 'Archive', description: 'Description', order: 1, folder_id: folder.id, file:)

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.archive).to be_persisted
      expect(action.archive.name).to eq 'Archive'
      expect(action.archive.description).to eq 'Description'
      expect(action.archive.order).to eq 1
      expect(action.archive.file).to be_attached
      expect(action.archive.folder).to eq folder
    end
  end

  describe 'Validations' do
    it 'If folder is not found, it should return an error' do
      action = described_class.new(name: 'Archive', description: 'Description', order: 1, folder_id: 9999)

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Pasta não encontrada')
    end

    it 'If archive is not valid, it should return an error' do
      action = described_class.new(name: 'Archive', description: 'Description', order: 1, file: nil)
      
      expect(action).not_to be_valid      
      expect(action.errors.full_messages).to include('Arquivo não pode ficar em branco')
    end
  end
end 
