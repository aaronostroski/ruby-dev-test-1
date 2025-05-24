class Folder < ApplicationRecord
  has_ancestry

  has_many :export_files, dependent: :destroy
  has_many :archives, dependent: :destroy
  accepts_nested_attributes_for :archives, allow_destroy: true

  validates :name, presence: true

  def all_sulfolders_with_archives
    folders = Folder.where(id: [ id ] + descendants.pluck(:id)).includes(:archives)

    result = folders.each_with_object({}) do |folder, hash|
      hash[folder] = folder.archives.to_a
    end

    result
  end
end
