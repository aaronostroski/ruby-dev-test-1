require "zip"

class DownloadFolder < ApplicationAction
  ZIP_PATH = Rails.root.join("tmp", "zip")

  attr_accessor :export_file_id

  validates :folder, :export_file_id, :export_file, presence: true

  def run
    export_file.update!(started_at: Time.current, error_at: nil, error_message: nil)

    folder_dir = Rails.root.join(ZIP_PATH, export_file.id.to_s).tap(&:mkpath)

    timestamp = I18n.l(Time.current, format: :job_datetime).parameterize
    zip_filename = "#{folder.name}-#{timestamp}.zip"
    file_zip_path = folder_dir.join(zip_filename)

    temp_paths = []

    Zip::File.open(file_zip_path, Zip::File::CREATE) do |zip|
      content.each do |folder, archives|
        folder_path = folder.path.map(&:name).join("/")

        archives.each do |archive|
          next unless archive.file.attached?

          ext = File.extname(archive.filename.to_s)
          temp_file_path = folder_dir.join("archive_#{archive.id}#{ext}")

          download_archive_file(archive, temp_file_path)
          add_to_zip(zip, folder_path, archive, temp_file_path)

          temp_paths << temp_file_path
        end
      end
    end

    export_file.file.attach(io: File.open(file_zip_path), filename: zip_filename)
    export_file.update!(filename: zip_filename, finished_at: Time.current, size: export_file.file.byte_size)
  rescue StandardError => e
    export_file.update!(error_at: Time.current, error_message: e.message)
  ensure
    temp_paths.each { |path| File.delete(path) if File.exist?(path) }
    File.delete(file_zip_path) if file_zip_path && File.exist?(file_zip_path)
  end

  def export_file
    @export_file ||= ExportFile.find_by(id: export_file_id)
  end

  def folder
    @folder ||= export_file&.folder
  end

  def content
    @content ||= folder.all_sulfolders_with_archives
  end

  def archives
    @archives ||= folder.archives
  end

  private

  def download_archive_file(archive, path)
    File.open(path, "wb") { |f| f.write(archive.file.download) }
  end

  def add_to_zip(zip, folder_path, archive, file_path)
    zip_path = "#{folder_path}/#{archive.file.filename}"
    zip.add(zip_path, file_path)
  end
end
