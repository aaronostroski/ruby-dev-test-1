class ExportFile < ApplicationRecord
  belongs_to :folder, optional: true

  has_one_attached :file

  before_create :set_requested_at

  def requested?
    requested_at.present? && started_at.nil? && finished_at.nil? && error_at.nil?
  end

  def started?
    started_at.present? && finished_at.nil? && error_at.nil?
  end

  def finished?
    finished_at.present? && error_at.nil?
  end

  def error?
    error_at.present?
  end

  def status
    return :requested if requested?
    return :started if started?
    return :finished if finished?
    :error if error?
  end

  private

  def set_requested_at
    self.requested_at = Time.current
  end
end
