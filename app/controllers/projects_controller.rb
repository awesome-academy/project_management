class ProjectsController < ApplicationController
  before_action :logged_in_user, only: :index

  def index
    @pagy, @projects = pagy filtered_projects, items: 8
    @selected_group = params[:group]
    @selected_status = params[:status]
  end

  private
  def filtered_projects
    projects = Project.all
    projects = filter_by_name(projects)
    projects = filter_by_group(projects)
    filter_by_status(projects)
  end

  def filter_by_name projects
    return projects if params[:name].blank?

    projects.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
  end

  def filter_by_group projects
    return projects if params[:group].blank?

    projects.where(group_id: params[:group])
  end

  def filter_by_status projects
    return projects if params[:status].blank?

    projects.where(status: params[:status])
  end
end
