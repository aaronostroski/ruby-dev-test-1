class CreateNewArchives < ApplicationAction
  attr_accessor :folder_id, :description, :files
  
  validate :files_should_be_present, :archives_should_be_valid
  validate :folder_should_exist, if: -> { folder_id.present? }

  def run
    archives.map(&:save!)      
  end

  def folder
    @folder ||= Folder.find_by(id: folder_id)
  end

  def archives    
    @archives ||= files.reject(&:blank?)&.map do |file|
      Archive.new(
        folder:,
        description:,
        file:
      )
    end
  end

  private

  def files_should_be_present 
    errors.add(:base, :files_not_found) unless files&.reject(&:blank?).present?
  end 

  def archives_should_be_valid    
    errors.add(:base, archives&.map(&:errors)&.flatten&.map(&:full_messages)) unless archives&.all?(&:valid?)
  end 

  def folder_should_exist
    errors.add(:base, :folder_not_found) unless folder.present?
  end
end