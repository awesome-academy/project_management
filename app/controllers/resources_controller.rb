class ResourcesController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @projects = Project.filter_name(params[:name])
                       .filter_date(params[:date])
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items
  end
end
