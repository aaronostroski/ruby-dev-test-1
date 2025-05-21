class UpdateFolder < ApplicationAction
  attr_accessor :name, :description, :folder_id, :parent_folder_id
  
  validate :folder_should_be_valid
  validate :parent_folder_should_exist, if: -> { parent_folder_id.present? }

  def run    
    folder.save!
  end

  def parent_folder
    @parent_folder ||= Folder.find_by(id: parent_folder_id)
  end

  def folder
    @folder ||= Folder.find(folder_id).tap do |folder|
      folder.name = name
      folder.description = description
      folder.parent_folder = parent_folder
    end
  end

  private

  def folder_should_be_valid
    errors.merge!(folder.errors) unless folder.valid?
  end 

  def parent_folder_should_exist
    errors.add(:base, :parent_folder_not_found) unless parent_folder.present?
  end
end