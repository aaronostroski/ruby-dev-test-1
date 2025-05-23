require 'rails_helper'

RSpec.describe Folder, type: :model do
  it 'Factory is valid' do
    expect(FactoryBot.build(:folder)).to be_valid
  end

  describe 'Path management' do
    it 'If parent folder is nil, the path is current on root' do
      root_folder = FactoryBot.create(:folder, parent_folder: nil)
      expect(root_folder.path).to eql([ root_folder ])
    end

    it 'If parent folder is not nil, the path is not on root' do
      root_folder = FactoryBot.create(:folder, parent_folder: nil)
      child_folder1 = FactoryBot.create(:folder, parent_folder: root_folder)
      child_folder2 = FactoryBot.create(:folder, parent_folder: child_folder1)

      expect(child_folder1.path).to eq([ root_folder, child_folder1 ])
      expect(child_folder1.path.pluck(:id)).to eq([ root_folder.id, child_folder1.id ])
      expect(child_folder1.path.pluck(:name)).to eq([ root_folder.name, child_folder1.name ])

      expect(child_folder2.path).to eq([ root_folder, child_folder1, child_folder2 ])
      expect(child_folder2.path.pluck(:id)).to eq([ root_folder.id, child_folder1.id, child_folder2.id ])
      expect(child_folder2.path.pluck(:name)).to eq([ root_folder.name, child_folder1.name, child_folder2.name ])
    end
  end

  describe 'Folder and subfolders' do
    it 'Should return all subfolders and archives' do
      root_folder = FactoryBot.create(:folder, parent_folder: nil)
      child_folder1 = FactoryBot.create(:folder, parent_folder: root_folder)
      child_folder2 = FactoryBot.create(:folder, parent_folder: child_folder1)

      archive1 = FactoryBot.create(:archive, folder: root_folder)
      archive2 = FactoryBot.create(:archive, folder: child_folder1)
      archive3 = FactoryBot.create(:archive, folder: child_folder2)

      result = root_folder.all_sulfolders_with_archives

      expect(result).to eq({
        root_folder => [ archive1 ],
        child_folder1 => [ archive2 ],
        child_folder2 => [ archive3 ]
      })
    end

    it 'Should return all subfolders and archives with no archives' do
      root_folder = FactoryBot.create(:folder, parent_folder: nil)
      child_folder1 = FactoryBot.create(:folder, parent_folder: root_folder)
      child_folder2 = FactoryBot.create(:folder, parent_folder: child_folder1)

      result = root_folder.all_sulfolders_with_archives

      expect(result).to eq({
        root_folder => [],
        child_folder1 => [],
        child_folder2 => []
      })
    end
  end

  describe 'Validations' do
    it 'Name should be present' do
      folder = FactoryBot.build(:folder, name: nil)
      expect(folder).not_to be_valid
      expect(folder.errors[:name]).to include("não pode ficar em branco")
    end
  end
end
