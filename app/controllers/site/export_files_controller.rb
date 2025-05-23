class Site::ExportFilesController < SiteController
  before_action :set_export_file, only: [ :download ]

  def index
    @export_files = ExportFile.order(created_at: :desc).page(params[:page])
  end


  def download
    if @export_file.file.attached? && @export_file.finished?
      send_data @export_file.file.download,
                filename: @export_file.filename,
                type: "zip",
                disposition: "attachment"
    else
      flash[:error] = t("views.defaults.resource_not_found")
      redirect_to home_path(folder_id: @archive.folder_id)
    end
  end

  private

  def set_export_file
    @export_file = ExportFile.find(params[:id])
  end
end
