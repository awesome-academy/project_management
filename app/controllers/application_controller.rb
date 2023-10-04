class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  include FormHelper
  include ProjectsHelper
  include MonthProjectFeaturesHelper
  include StatisticsResourcesHelper
  include ReleasePlansHelper
  before_action :set_locale

  add_breadcrumb I18n.t("breadcrumbs.homepage"), :root_path

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash_logged_in_user_danger"
    redirect_to login_url, status: :see_other
  end

  def correct_user
    redirect_to(root_url, status: :see_other) unless current_user? @user
  end

  def find_project
    @project = Project.find_by id: params[:project_id] || params[:id]
    return if @project

    flash[:warning] = t "errors.project_not_found"
    redirect_to root_path
  end

  def find_report
    @report = Report.find_by id: params[:id]
    return if @report

    flash[:warning] = t "errors.report_not_found"
    redirect_to root_path
  end

  def check_valid_project redirect_url, project_id
    @project = Project.find_by id: project_id
    return if @project && current_user.can_edit_delete_project?(@project)

    flash[:danger] = t "errors.permission_update_delete_project"
    redirect_to redirect_url, status: :see_other
  end

  def find_release_plan
    @release_plan = ReleasePlan.find_by id: params[:id]
    return if @release_plan

    flash[:warning] = t "errors.release_plan_not_found"
    redirect_to :root, status: :see_other
  end

  def find_health_item
    @health_item = HealthItem.find_by id: params[:id]
    return if @health_item

    flash[:warning] = t "errors.health_item_not_found"
    redirect_to health_items_path
  end

  def find_lesson_learn
    @lesson_learn = LessonLearn.find_by id: params[:id]
    return if @lesson_learn

    flash[:warning] = t "errors.lesson_learn_not_found"
    redirect_to lesson_learns_path
  end
end
