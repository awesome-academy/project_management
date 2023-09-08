class ResourcesController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @projects = Project.filter_name(params[:name])
                       .filter_date(params[:date])
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items
  end

  def new
    @project_id = params[:project_id]
    @project_user = ProjectUser.new
  end

  def create
    if params[:date].present?
      date = Date.parse params[:date]
      flash[:warning] = date.month
    end
    redirect_to new_resource_path
  end

  # def create
  #   return if params[:member_efforts].nil?
  #   member_efforts = params[:member_efforts]
  #   @project_user_resource = ProjectUserResource.new
  #   project_id = params[:project_id]

  #   sum_efforts = 0
  #   member_efforts.each do |user_id, effort|
  #     effort = effort.to_f
  #     max = 100
  #     min = 0

  #     if effort > max or effort < min
  #       flash[:warning] = "Effort number is not valid"
  #       redirect_to "/resources/new"
  #       return
  #     end

  #     if sum_efforts == 0
  #       flash[:warning] = "At least 1 member have effort"
  #       redirect_to "/resources/new"
  #       return
  #     end

  #     project_user_id = ProjectUser.find_by(user_id: user_id, project_id: project_id).select(:id)
  #     project_user_resources
  #   end

  #   # Hoàn thành xử lý
  #   flash[:success] = sum_efforts
  #   redirect_to "/resources/new"
  # end

  private
  def is_valid_effort number
    return true if number >= 0 and number <= 100
    flash[:warning] = "invalid effort"
  end

end
