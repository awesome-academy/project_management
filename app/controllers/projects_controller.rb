class ProjectsController < ApplicationController
  before_action :logged_in_user, only: :index

  def index
    @projects = Project.filter_name(params[:name])
                       .filter_group(params[:group])
                       .filter_status(params[:status])
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items
    @selected_group = params[:group]
    @selected_status = params[:status]
  end
end
