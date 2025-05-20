require 'ostruct'

class Site::HomeController < SiteController
  def index
    @filters = parse_filters
        
    folders = Folder.all
    folders = folders.where(parent_folder_id: @filters.folder_id) if @filters.folder_id
    @folders = folders.order(:name)

    archives = Archive.all
    archives = archives.where(folder_id: @filters.folder_id) if @filters.folder_id
    @archives = archives.order(:name)
  end

  private

  def parse_filters
    @filters = OpenStruct.new(params[:filters])
  end
end
  