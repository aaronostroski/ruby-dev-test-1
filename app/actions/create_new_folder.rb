class CreateNewFolder < ApplicationAction
  attr_accessor :name, :description, :parent_folder_id, :order
  
  validate :folder_should_be_valid
  validate :parent_folder_should_exist, if: -> { parent_folder_id.present? }
  
  def run
    folder.save!
  end

  def parent_folder
    @parent_folder ||= Folder.find_by(id: parent_folder_id)
  end

  def folder
    @folder ||= Folder.new(
      name:,
      description:,
      parent_folder:,
      order:,
    )
  end

  private

  def folder_should_be_valid
    errors.add(:base, folder.errors.full_messages.join(', ')) unless folder.valid?
  end 

  def parent_folder_should_exist
    errors.add(:base, :parent_folder_not_found) unless parent_folder.present?
  end
end