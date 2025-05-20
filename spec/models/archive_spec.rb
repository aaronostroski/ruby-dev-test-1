require 'rails_helper'

RSpec.describe Archive, type: :model do
  it 'Factory is valid' do
    expect(FactoryBot.build(:archive)).to be_valid
  end
  
  describe 'Validations' do
    it 'File should be present' do
      folder = FactoryBot.create(:folder)
      archive = FactoryBot.build(:archive, folder:, file: nil)

      expect(archive).to_not be_valid
      expect(archive.errors[:file]).to include('não pode ficar em branco')
    end
  end
end