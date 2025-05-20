class Archive < ApplicationRecord
  belongs_to :folder, optional: true

  has_one_attached :file

  validates :name, :file, presence: true

  before_validation :set_name, if: -> { name.blank? }

  def human_size
    units = %w[B KB MB GB TB]
    size = file.blob.byte_size.to_f
    index = 0

    while size >= 1024 && index < units.length - 1
      size /= 1024
      index += 1
    end

    "#{format('%.2f', size)} #{units[index]}"
  end

  def type
    file&.blob&.content_type
  end

  def filename
    file&.blob&.filename&.to_s
  end

  private

  def set_name
    self.name = filename
  end
end
