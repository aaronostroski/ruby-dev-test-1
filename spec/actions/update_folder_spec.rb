require 'rails_helper'

RSpec.describe UpdateFolder do
  let!(:folder) { FactoryBot.create(:folder) }

  describe 'Happy path' do
    it 'User updates folder with no parent folder' do
      expect(folder.name).to_not eq 'New Folder'
      expect(folder.description).to_not eq 'Description'
      expect(folder.parent_folder).to be_nil

      action = described_class.new(folder_id: folder.id, name: 'New Folder', description: 'Description')

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.folder.name).to eq 'New Folder'
      expect(action.folder.description).to eq 'Description'
      expect(action.folder.parent_folder).to be_nil
      expect(action.folder.archives).to be_empty
    end

    it 'User updates folder with parent folder' do
      expect(folder.name).to_not eq 'New Folder'
      expect(folder.description).to_not eq 'Description'
      expect(folder.parent_folder).to be_nil

      parent_folder = FactoryBot.create(:folder)
      action = described_class.new(folder_id: folder.id, name: 'New Folder', description: 'Description', parent_folder_id: parent_folder.id)

      expect(action).to be_valid
      expect(action.save).to be true

      expect(action.folder.name).to eq 'New Folder'
      expect(action.folder.description).to eq 'Description'
      expect(action.folder.parent_folder).to eq parent_folder
      expect(action.folder.archives).to be_empty
    end
  end

  describe 'Validations' do
    it 'If parent folder is not found, it should return an error' do
      action = described_class.new(folder_id: folder.id, name: 'New Folder', description: 'Description', parent_folder_id: 9999)

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Pasta não encontrada')
    end

    it 'If folder is not valid, it should return an error' do
      action = described_class.new(folder_id: folder.id, name: '', description: 'Description')

      expect(action).not_to be_valid
      expect(action.errors.full_messages).to include('Name não pode ficar em branco')
    end
  end
end
