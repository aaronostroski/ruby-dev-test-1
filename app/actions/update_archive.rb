class UpdateArchive < ApplicationAction
  attr_accessor :archive_id, :folder_id, :name, :description, :file

  validate :archive_should_be_valid
  validate :folder_should_exist, if: -> { folder_id.present? }

  def run
    archive.save!
  end

  def folder
    @folder ||= Folder.find_by(id: folder_id)
  end

  def archive
    @archive ||= Archive.find_by(id: archive_id).tap do |archive|
      archive.name = name
      archive.description = description
      archive.file = file
      archive.folder = folder
    end
  end

  private

  def archive_should_be_valid
    errors.merge!(archive.errors) unless archive.valid?
  end

  def folder_should_exist
    errors.add(:base, :folder_not_found) unless folder.present?
  end
end
