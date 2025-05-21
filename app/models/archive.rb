class Archive < ApplicationRecord
  belongs_to :folder, optional: true

  has_one_attached :file

  validates :name, :file, presence: true

  before_validation :set_name, if: -> { name.blank? }
  before_save :set_size, :set_content_type, if: -> { attachment_changes.any? }

  def filename
    file&.blob&.filename&.to_s
  end

  def pdf?
    content_type.match?("pdf")
  end

  def image?
    content_type.match?("image")
  end

  def video?
    content_type.match?("video")
  end

  def csv_or_xlsx?
    content_type.match?("csv") || content_type.match?("sheet")
  end

  def zip?
    content_type.match?("zip")
  end

  private

  def set_name
    self.name = filename
  end

  def set_size
    self.size = file.blob.byte_size
  end

  def set_content_type
    content_type = file&.blob&.content_type
    content_type = content_type.gsub("application/", "") if content_type&.match?(/application\//)
    self.content_type = content_type
  end
end
