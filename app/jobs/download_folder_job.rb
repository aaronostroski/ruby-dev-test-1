class DownloadFolderJob < ApplicationJob
  queue_as :export_files

  def perform(export_file_id)
    DownloadFolder.new(export_file_id:).save
  rescue StandardError => e
    raise StandardError, e.message
  end
end
