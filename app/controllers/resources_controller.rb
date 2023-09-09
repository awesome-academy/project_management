class ResourcesController < ApplicationController
  before_action :logged_in_user, only: %i(create new index)
  before_action :validate_create_form, only: :create

  def index
    @projects = Project.filter_name(params[:name])
                       .filter_date(params[:date])
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items
  end

  def new
    @project_user = ProjectUser.new
    return if params[:project_id].blank?

    @project_id = params[:project_id]
  end

  def create
    date = Date.parse(params[:project_user][:joined_at])
    @month = date.month
    @year = date.year
    @project_id = params[:project_user][:project_id]
    @list_params = params[:project_user][:project_user_resources_attributes]

    if create_resources
      flash[:success] = t(".create_success")
      redirect_to resources_path
    else
      flash[:danger] = t(".create_fail")
      redirect_to new_resource_path
    end
  end

  private

  def validate_create_form
    return if params[:project_user][:project_user_resources_attributes].present?

    flash[:danger] = t ".at_least_1"
    redirect_to new_resource_path
  end

  def create_resources
    @list_params.each do |_key, resource_params|
      user_id = resource_params["project_user_id"].to_i
      percentage = resource_params["percentage"].to_i
      man_month = percentage.to_f / 100.0
      project_user = ProjectUser.find_by(user_id:,
                                         project_id: @project_id)

      return false if project_user.nil?

      new_resource = ProjectUserResource.new(
        project_user_id: project_user.id,
        percentage:,
        month: @month,
        year: @year,
        man_month:
      )

      return false unless new_resource.save
    end
    true
  end
end
