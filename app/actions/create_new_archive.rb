class CreateNewArchive < ApplicationAction
  attr_accessor :folder_id, :name, :description, :order, :file
  
  validate :archive_should_be_valid
  validate :folder_should_exist, if: -> { folder_id.present? }
  
  def run
    archive.save!
  end

  def folder
    @folder ||= Folder.find_by(id: folder_id)
  end

  def archive
    @archive ||= Archive.new(
      folder:,
      name:,
      description:,
      order:,
      file:,
    )
  end

  private

  def archive_should_be_valid
    errors.add(:base, archive.errors.full_messages.join(', ')) unless archive.valid?
  end 

  def folder_should_exist
    errors.add(:base, :folder_not_found) unless folder.present?
  end
end