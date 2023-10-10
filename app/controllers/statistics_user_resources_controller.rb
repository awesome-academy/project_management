class StatisticsUserResourcesController < ApplicationController
  before_action :logged_in_user
  before_action :filter, only: :index
  add_breadcrumb I18n.t("layouts.sidebar.statistics_resources"),
                 :statistics_resources_path

  def index
    @pagy, @users = pagy @users,
                         items: params[:per_page] ||
                                Settings.pagy.number_items_10
    respond
  end

  private
  def respond
    respond_to do |format|
      format.html
      format.xlsx do
        date = Time.zone.now.strftime Settings.date.format
        header = "attachment; filename=#{date}_statistics_user_resources.xlsx"
        response.headers["Content-Disposition"] = header
      end
    end
  end

  def filter
    name = params[:name].strip if params[:name]
    year = params[:year] || Time.zone.now.year
    @users = User.filter_group(params[:group_id])
                 .filter_year(year)
                 .filter_name(name)
                 .filter_project(params[:project_id])
  end
end
