require 'rails_helper'

RSpec.describe CreateNewFolder do
  describe 'Happy path' do
    it 'User creates new folder with no parent folder' do
      action = described_class.new(name: 'New Folder', description: 'Description')

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.folder).to be_persisted
      expect(action.folder.name).to eq 'New Folder'
      expect(action.folder.description).to eq 'Description'
      expect(action.folder.parent_folder).to be_nil
      expect(action.folder.archives).to be_empty
    end

    it 'User creates new folder with parent folder' do
      parent_folder = FactoryBot.create(:folder)
      action = described_class.new(name: 'New Folder', description: 'Description', parent_folder_id: parent_folder.id)

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.folder).to be_persisted
      expect(action.folder.name).to eq 'New Folder'
      expect(action.folder.description).to eq 'Description'
      expect(action.folder.parent_folder).to eq parent_folder
      expect(action.folder.archives).to be_empty
    end

    it 'If user creates new folder passing files to it, it should create the archives' do
      files = [
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.zip'), 'application/zip'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpeg'), 'image/jpeg'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.pdf'), 'application/pdf'),
      ]

      action = described_class.new(name: 'New Folder', description: 'Description', files:)

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.folder).to be_persisted
      expect(action.folder.name).to eq 'New Folder'
      expect(action.folder.description).to eq 'Description'
      expect(action.folder.archives.count).to eq 3
      expect(action.folder.archives.pluck(:folder_id)).to all(eq action.folder.id)
      expect(action.folder.archives.pluck(:name)).to include('test.zip', 'test.jpeg', 'test.pdf')
    end
  end

  describe 'Validations' do
    it 'If parent folder is not found, it should return an error' do
      action = described_class.new(name: 'New Folder', description: 'Description', parent_folder_id: 9999)

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Pasta não encontrada')
    end

    it 'If folder is not valid, it should return an error' do
      action = described_class.new(name: '', description: 'Description')

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Name não pode ficar em branco')
    end
  end
end
