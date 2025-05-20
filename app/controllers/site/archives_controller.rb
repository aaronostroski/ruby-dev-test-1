class Site::ArchivesController < SiteController
  def new
    @archive = Archive.new
  end

  def create        
    action = CreateNewArchives.new(form_params.to_h)
    
    if action.save
      flash[:success] = t('views.defaults.sucessfully_created')
      redirect_to home_path(folder_id: action.folder_id)
    else        
      flash[:error] = action.errors.full_messages.join(', ')      
      redirect_to new_site_archive_path, status: :unprocessable_entity
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
end
  