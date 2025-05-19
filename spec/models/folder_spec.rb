require 'rails_helper'

RSpec.describe Folder, type: :model do
  it 'Factory is valid' do
    expect(FactoryBot.build(:folder)).to be_valid
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