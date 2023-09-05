class ResourcesController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @projects = Project.filled_in
                       .filter_name(params[:name])
                       .filter_date(params[:date])
    @pagy, @projects = pagy @projects, items: 8
  end
end
