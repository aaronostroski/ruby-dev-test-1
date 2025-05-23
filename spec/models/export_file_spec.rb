require 'rails_helper'

RSpec.describe ExportFile, type: :model do
  it 'Factory is valid' do
    expect(FactoryBot.build(:folder)).to be_valid
  end

  describe 'Status management' do
    it 'Should be requested when created' do
      export_file_requested = FactoryBot.create(:export_file)
      expect(export_file_requested).to be_requested
    end

    it 'Should be started when started at is set and finished at is nil' do
      export_file_started = FactoryBot.create(:export_file, :started)
      expect(export_file_started).to be_started
    end

    it 'Should be finished when finished at is set and error at is nil' do
      export_file_finished = FactoryBot.create(:export_file, :finished)
      expect(export_file_finished).to be_finished
      expect(export_file_finished.file).to be_attached
    end

    it 'Should be error when error at is set' do
      export_file_error = FactoryBot.create(:export_file, :error)
      expect(export_file_error).to be_error
    end
  end
end
