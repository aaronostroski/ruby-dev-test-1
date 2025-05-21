class Archive < ApplicationRecord
  belongs_to :folder, optional: true

  has_one_attached :file

  validates :name, :file, presence: true

  before_validation :set_name, if: -> { name.blank? }
  before_create :set_size

  def type
    type = file&.blob&.content_type
    type = type.gsub('application/', '') if type&.match?(/application\//)
    type = type.gsub('image/', '') if type&.match?(/image\//)
    type
  end

  def filename
    file&.blob&.filename&.to_s
  end

  def pdf?    
    type.match?('pdf')
  end

  def image?
    file&.blob&.image?
  end

  def video?
    file&.blob&.video?
  end

  def csv_or_xlsx?
    type.match?('csv') || type.match?('sheet')
  end

  def zip?
    type.match?('zip')
  end

  private

  def set_name
    self.name = filename
  end

  def set_size
    self.size = file.blob.byte_size
  end
end
