class ResourcesController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @projects = Project.all
  end
end
