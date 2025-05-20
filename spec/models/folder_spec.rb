require 'rails_helper'

RSpec.describe Folder, type: :model do
  it 'Factory is valid' do
    expect(FactoryBot.build(:folder)).to be_valid
  end

  describe 'Path management' do
    it 'If parent folder is nil, the path is current on root' do
      root_folder = FactoryBot.create(:folder, parent_folder: nil)
      expect(root_folder.path).to be_empty
    end

    it 'If parent folder is not nil, the path is not on root' do
      root_folder = FactoryBot.create(:folder, parent_folder: nil)
      child_folder1 = FactoryBot.create(:folder, parent_folder: root_folder)
      child_folder2 = FactoryBot.create(:folder, parent_folder: child_folder1)

      expect(child_folder1.path).to eq([root_folder])
      expect(child_folder1.path.pluck(:id)).to eq([root_folder.id])
      expect(child_folder1.path.pluck(:name)).to eq([root_folder.name])

      expect(child_folder2.path).to eq([root_folder, child_folder1])
      expect(child_folder2.path.pluck(:id)).to eq([root_folder.id, child_folder1.id])
      expect(child_folder2.path.pluck(:name)).to eq([root_folder.name, child_folder1.name])
    end
  end

  describe 'Validations' do
    it 'Can have the same order in different parent folders' do
      parent_folder = FactoryBot.create(:folder)
      folder1 = FactoryBot.create(:folder, parent_folder: parent_folder, order: 1)
      folder2 = FactoryBot.create(:folder, parent_folder: parent_folder, order: 2)

      expect(folder1).to be_valid
      expect(folder2).to be_valid

      folder3 = FactoryBot.build(:folder, parent_folder: parent_folder, order: 1)
            
      expect(folder3).not_to be_valid
      expect(folder3.errors[:order]).to include("informado(a) já está em uso")
    end
  end
end