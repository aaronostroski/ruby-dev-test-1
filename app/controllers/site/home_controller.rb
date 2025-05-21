require 'ostruct'

class Site::HomeController < SiteController
  before_action :set_filters, :set_archives, :set_folders, :set_current_folder, :set_totals, only: [:index]

  def index; end;

  private

  def set_archives
    archives = Archive.all    
    archives = archives.where(folder_id: @filters.folder_id) if @filters.folder_id.present?
    archives = archives.where(folder_id: nil) unless @filters.folder_id&.present?

    @archives = archives.order(:name)
  end

  def set_folders
    folders = Folder.all
    folders = folders.where(parent_folder_id: @filters.folder_id) if @filters.folder_id.present?
    folders = folders.where(parent_folder_id: nil) unless @filters.folder_id&.present?

    @folders = folders.order(:name)
  end

  def set_current_folder
    @current_folder = Folder.find(@filters.folder_id) if @filters.folder_id.present?
  end

  def set_filters
    @filters = OpenStruct.new(params[:filters])
  end
end
  