class ReleasePlansController < ApplicationController
  before_action :logged_in_user, only: %i(edit update index new show destroy)
  before_action :find_release_plan, only: %i(edit update show destroy)
  before_action only: :update do
    check_valid_project edit_release_plan_url,
                        params.dig(:release_plan, :project_id)
  end

  add_breadcrumb I18n.t("breadcrumbs.release_plans"), :release_plans_path

  def index
    @release_plans = ReleasePlan.filter_name(params[:name])
                                .filter_status(params[:status])
                                .in_date_range(params[:date_from],
                                               params[:date_to])
                                .by_recently_created
                                .includes(:project)
    @pagy, @release_plans = pagy @release_plans,
                                 items: Settings.pagy.number_items_10
  end

  def new
    @release_plan = ReleasePlan.new
    add_breadcrumb t("breadcrumbs.new"), :new_release_plan_path
  end

  def create
    @release_plan = ReleasePlan.new release_plan_params
                               .merge(creator_id: current_user.id)
    if @release_plan.save
      flash[:success] = t ".create_success"
      redirect_to release_plans_path
    else
      flash[:danger] = t ".fail_create"
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    @projects = current_user.valid_projects_by_role
    add_breadcrumb @release_plan.project_name,
                   project_path(@release_plan.project)
    add_breadcrumb t("breadcrumbs.edit"), :edit_release_plan_path
  end

  def update
    if @release_plan.update release_plan_params
      flash[:success] = t(".update_success")
      redirect_to release_plans_path
    else
      @projects = current_user.valid_projects_by_role
      flash[:danger] = t(".update_danger")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @release_plan.destroy
      flash[:success] = t ".delete_success"
      redirect_to release_plans_url
    else
      flash[:danger] = t ".fail_delete"
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  private
  def release_plan_params
    params.require(:release_plan).permit ReleasePlan::UPDATE_ATTRS
  end
end
