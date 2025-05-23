require "ostruct"

class Site::FoldersController < SiteController
  before_action :set_folder, only: [ :edit, :update, :destroy, :download ]
  before_action :set_filters, only: [ :new ]

  def new
    @folder = Folder.new
  end

  def create
    action = CreateNewFolder.new(form_params.to_h)

    if action.save
      flash[:success] = t("views.defaults.sucessfully_created")
      redirect_to home_path(filters: { folder_id: action&.archives.any? ? action&.folder&.id : action&.parent_folder&.id })
    else
      flash[:error] = action.errors.full_messages.join(", ")
      redirect_to new_site_folder_path, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    action = UpdateFolder.new(form_params.merge(folder_id: @folder.id).to_h)

    if action.save
      flash[:success] = t("views.defaults.sucessfully_updated")
      redirect_to home_path(filters: { folder_id: action&.parent_folder&.id })
    else
      flash[:error] = action.errors.full_messages.join(", ")
      redirect_to edit_site_folder_path, status: :unprocessable_entity
    end
  end

  def destroy
    @folder.destroy
    flash[:success] = t("views.defaults.sucessfully_deleted")
    redirect_to home_path(filters: { folder_id: @folder&.id })
  end

  def download
    export_file = ExportFile.new(folder: @folder)

    if export_file.save
      DownloadFolderJob.perform_later(export_file.id)
      flash[:success] = t("views.defaults.sucessfully_downloaded")
      redirect_to site_export_files_path
    else
      flash[:error] = export_file.errors.full_messages.join(", ")
      redirect_to home_path(filters: { folder_id: @folder&.id }), status: :unprocessable_entity
    end
  end

  private

  def form_params
    params.require(:folder).permit(
      :name,
      :description,
      :parent_folder_id,
      files: []
    )
  end

  def set_filters
    @filters = OpenStruct.new(params[:filters])
  end

  def set_folder
    @folder = Folder.find(params[:id])
  end
end
