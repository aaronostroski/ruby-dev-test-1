class Folder < ApplicationRecord
  belongs_to :parent_folder, class_name: 'Folder', optional: true

  validates :name, presence: true
  validates :order, numericality: { greater_than: 0 }, uniqueness: { scope: [:parent_folder_id] }
end
