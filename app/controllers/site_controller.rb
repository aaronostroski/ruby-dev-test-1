class SiteController < ApplicationController
  before_action :set_totals
  layout 'site'

  def set_totals
    @totals = {
      folders: Folder.count,
      archives: Archive.count,
      size: Archive.sum(:size)
    }
  end
end
