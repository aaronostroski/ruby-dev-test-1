class Archive < ApplicationRecord
  belongs_to :folder, optional: true

  has_one_attached :file

  validates :name, :file, presence: true
  validates :order, numericality: { greater_than: 0 }, uniqueness: { scope: [:folder_id] }

  before_validation :set_name, if: -> { name.blank? }

  def size
    file.blob.byte_size
  end

  def type
    file.blob.content_type
  end

  private

  def set_name
    self.name = file.filename.to_s
  end
end
