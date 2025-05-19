require 'rails_helper'

RSpec.describe CreateNewFolder do
  describe 'Happy path' do
    it 'User creates new folder with no parent folder' do
      action = described_class.new(name: 'New Folder', description: 'Description', order: 1)

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.folder).to be_persisted
      expect(action.folder.name).to eq 'New Folder'
      expect(action.folder.description).to eq 'Description'
      expect(action.folder.parent_folder).to be_nil
    end

    it 'User creates new folder with parent folder' do
      parent_folder = FactoryBot.create(:folder)
      action = described_class.new(name: 'New Folder', description: 'Description', order: 1, parent_folder_id: parent_folder.id)

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.folder).to be_persisted
      expect(action.folder.name).to eq 'New Folder'
      expect(action.folder.description).to eq 'Description'
      expect(action.folder.parent_folder).to eq parent_folder
    end
  end

  describe 'Validations' do
    it 'If parent folder is not found, it should return an error' do
      action = described_class.new(name: 'New Folder', description: 'Description', order: 1, parent_folder_id: 9999)

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Pasta não encontrada')
    end

    it 'If folder is not valid, it should return an error' do
      action = described_class.new(name: '', description: 'Description', order: 1)

      expect(action).not_to be_valid      
      expect(action.errors.full_messages).to include('Nome não pode ficar em branco')
    end
  end
end 
