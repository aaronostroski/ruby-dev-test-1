class Site::FoldersController < SiteController
  def new
    @folder = Folder.new
    @folder.archives.build
  end

  def create    
    action = CreateNewFolder.new(form_params.to_h)
    
    if action.save
      flash[:success] = t('views.defaults.sucessfully_created')
      redirect_to home_path(folder_id: action.folder.id)
    else
      flash[:error] = action.errors.full_messages.join(', ')
      redirect_to new_site_folder_path, status: :unprocessable_entity
    end
  end

  private

  def form_params
    params.require(:folder).permit(
      :name, 
      :description, 
      :parent_folder_id
    )
  end
end
  