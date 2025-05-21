class Folder < ApplicationRecord
  belongs_to :parent_folder, class_name: 'Folder', optional: true

  has_many :parent_folders, class_name: 'Folder', dependent: :destroy, foreign_key: :parent_folder_id
  has_many :archives, dependent: :destroy

  validates :name, presence: true

  def path
    full_path = []

    current_folder = self

    while current_folder.present?
      full_path << current_folder
      current_folder = current_folder.parent_folder
    end

    full_path = full_path.reverse
    full_path || []
  end
end
