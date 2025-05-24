class UpdateFolder < ApplicationAction
  attr_accessor :name, :description, :folder_id, :parent_id

  validate :folder_should_be_valid
  validate :parent_should_exist, if: -> { parent_id.present? }

  def run
    folder.save!
  end

  def parent
    @parent ||= Folder.find_by(id: parent_id)
  end

  def folder
    @folder ||= Folder.find(folder_id).tap do |folder|
      folder.name = name
      folder.description = description
      folder.parent = parent
    end
  end

  private

  def folder_should_be_valid
    errors.merge!(folder.errors) unless folder.valid?
  end

  def parent_should_exist
    errors.add(:base, :parent_not_found) unless parent.present?
  end
end
