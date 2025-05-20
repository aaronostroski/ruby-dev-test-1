require 'rails_helper'

RSpec.describe Archive, type: :model do
  it 'Factory is valid' do
    expect(FactoryBot.build(:archive)).to be_valid
  end
  
  describe 'Validations' do
    it 'Can have the same order in different folder' do
      folder = FactoryBot.create(:folder)
      archive1 = FactoryBot.create(:archive, folder:, order: 1)
      archive2 = FactoryBot.create(:archive, folder:, order: 2)

      expect(archive1).to be_valid
      expect(archive2).to be_valid

      archive3 = FactoryBot.build(:archive, folder:, order: 1)
            
      expect(archive3).not_to be_valid
      expect(archive3.errors[:order]).to include("informado(a) já está em uso")
    end
  end
end