class Folder < ApplicationRecord
  belongs_to :parent_folder, class_name: 'Folder', optional: true

  validates :name, presence: true
  validates :order, numericality: { greater_than: 0 }, uniqueness: { scope: [:parent_folder_id] }

  def path
    full_path = []

    current_folder = self

    while current_folder.present?
      full_path << current_folder
      current_folder = current_folder.parent_folder
    end

    full_path = full_path.reverse
    full_path.pop
    full_path || []
  end
end
