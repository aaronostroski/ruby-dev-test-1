require 'rails_helper'

RSpec.describe DownloadFolder do
  let!(:root_folder) { FactoryBot.create(:folder) }
  let!(:export_file) { FactoryBot.create(:export_file, folder: root_folder) }

  before do
    expect(export_file).to be_requested
  end

  describe 'Happy path' do
    it 'Should zip the folder and all subfolders' do
      root_folder = FactoryBot.create(:folder, parent_folder: nil)
      child_folder1 = FactoryBot.create(:folder, parent_folder: root_folder)
      child_folder2 = FactoryBot.create(:folder, parent_folder: child_folder1)
      child_folder3 = FactoryBot.create(:folder, parent_folder: child_folder2)

      archive1 = FactoryBot.create(:archive, folder: root_folder)
      archive2 = FactoryBot.create(:archive, :csv, folder: child_folder1)
      archive3 = FactoryBot.create(:archive, :pdf, folder: child_folder2)
      archive4 = FactoryBot.create(:archive, :video, folder: child_folder2)
      archive5 = FactoryBot.create(:archive, :image, folder: child_folder3)

      action = described_class.new(export_file_id: export_file.id)

      expect(action).to be_valid
      expect(action.save).to be_truthy

      export_file.reload

      expect(export_file).to be_finished
      expect(export_file.file).to be_attached
      expect(export_file.file.byte_size).to be > 0
      expect(export_file.file.content_type).to eq('application/zip')
      expect(export_file.size).to be > 0
      expect(export_file.error_at).to be_nil
      expect(export_file.error_message).to be_nil
      expect(export_file.finished_at).to be_present
    end

    it 'Should zip the folder and all subfolders with no archives' do
      root_folder = FactoryBot.create(:folder, parent_folder: nil)
      child_folder1 = FactoryBot.create(:folder, parent_folder: root_folder)
      child_folder2 = FactoryBot.create(:folder, parent_folder: child_folder1)
      child_folder3 = FactoryBot.create(:folder, parent_folder: child_folder2)

      action = described_class.new(export_file_id: export_file.id)

      expect(action).to be_valid
      expect(action.save).to be_truthy

      export_file.reload

      expect(export_file).to be_finished
      expect(export_file.file).to be_attached
      expect(export_file.file.byte_size).to be > 0
      expect(export_file.file.content_type).to eq('application/zip')
      expect(export_file.size).to be > 0
      expect(export_file.error_at).to be_nil
      expect(export_file.error_message).to be_nil
      expect(export_file.finished_at).to be_present
    end
  end

  describe 'Validations' do
    it 'If throws an error, should set the error message and status must be error' do
      archive = FactoryBot.create(:archive, folder: root_folder)

      action = described_class.new(export_file_id: export_file.id)

      allow(action).to receive(:content).and_return({ root_folder => [ archive ] })
      allow(archive.file.blob).to receive(:download).and_raise(StandardError, "Test error")

      expect { action.run }.not_to raise_error

      export_file.reload

      expect(export_file).to be_error
      expect(export_file.error_at).to be_present
      expect(export_file.error_message).to eq("Test error")
    end

    it 'Presence of the export_file_id' do
      action = described_class.new(export_file_id: nil)

      expect(action).not_to be_valid
      expect(action.errors[:export_file_id]).to include("não pode ficar em branco")
    end

    it 'Presence of the folder' do
      action = described_class.new(export_file_id: export_file.id)

      allow(action).to receive(:folder).and_return(nil)

      expect(action).not_to be_valid
      expect(action.errors[:folder]).to include("não pode ficar em branco")
    end
  end
end
