class Site::ArchivesController < SiteController
  before_action :set_archive, only: [:destroy, :download]
  before_action :set_filters, only: [:new]

  def new
    @archive = Archive.new
  end

  def create        
    action = CreateNewArchives.new(form_params.to_h)
        
    if action.save
      flash[:success] = t('views.defaults.sucessfully_created')
      redirect_to home_path(filters: { folder_id: action.folder_id })
    else        
      flash[:error] = action.errors.full_messages.join(', ')      
      redirect_to new_site_archive_path, status: :unprocessable_entity
    end
  end

  def destroy
    @archive.destroy
    flash[:success] = t('views.defaults.sucessfully_deleted')
    redirect_to home_path(filters: { folder_id: @archive&.id })
  end

  def download
    if @archive.file.attached?
      send_data @archive.file.download,
                filename: @archive.filename,
                type: @archive.type,
                disposition: 'attachment'
    else
      flash[:error] = t('views.defaults.resource_not_found')
      redirect_to home_path(folder_id: @archive.folder_id)
    end
  end

  private

  def form_params
    params.require(:archive).permit(
      :folder_id,
      :name, 
      :description, 
      files: []
    )
  end

  def set_archive
    @archive = Archive.find(params[:id])
  end

  def set_filters
    @filters = OpenStruct.new(params[:filters])
  end
end
  