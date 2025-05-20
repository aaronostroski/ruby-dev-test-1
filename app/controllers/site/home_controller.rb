class Site::HomeController < SiteController
  def index
    @folders = Folder.order(:name)
    @archives = Archive.order(:name)
  end
end
  