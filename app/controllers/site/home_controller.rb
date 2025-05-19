class Site::HomeController < SiteController
  def index
    @folders = Folder.all
  end
end
  