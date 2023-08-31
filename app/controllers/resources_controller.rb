class ResourcesController < ApplicationController
  # before_action :logged_in_user, only: :index
  def index
    @pagy, @projects = pagy filtered_projects, items: 8
  end

  private
  def filtered_projects
    projects = Project.all
    projects = filter_by_filled_in projects
    filter_by_name projects
  end

  def filter_by_name projects
    return projects if params[:name].blank?

    projects.search_by_name(params[:name])
  end

  def filter_by_filled_in projects
    projects.includes(:reports).where.not(reports: {id: nil})
  end
end
