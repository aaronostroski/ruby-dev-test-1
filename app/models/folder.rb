class Folder < ApplicationRecord
  belongs_to :parent_folder, class_name: "Folder", optional: true

  has_many :subfolders, class_name: "Folder", dependent: :destroy, foreign_key: :parent_folder_id
  has_many :archives, dependent: :destroy
  accepts_nested_attributes_for :archives, allow_destroy: true

  validates :name, presence: true

  def all_sulfolders_with_archives
    result = { self => self.archives.to_a }

    subfolders.each do |subfolder|
      result.merge!(subfolder.all_sulfolders_with_archives)
    end

    result
  end

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
