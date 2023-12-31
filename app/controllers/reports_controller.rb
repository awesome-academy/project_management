class ReportsController < ApplicationController
  before_action :logged_in_user, only: %i(create new index destroy show)
  before_action only: :create do
    check_valid_project new_report_url,
                        params.dig(:report, :project_id)
  end
  before_action :find_report, only: %i(show destroy edit update)
  before_action :check_role, only: :destroy

  add_breadcrumb I18n.t("breadcrumbs.reports"), :reports_path

  def index
    @all_reports = Report.filter_start_date(params[:start_date])
                         .filter_end_date(params[:end_date])
                         .filter_name_status(params[:name], params[:status])
                         .by_recently_created
    @pagy, @reports = pagy @all_reports, items: Settings.pagy.number_items_10

    respond
  end

  def new
    @report = Report.new
    @projects = current_user.valid_projects_by_role
    add_breadcrumb t("breadcrumbs.new"), new_report_path
  end

  def create
    @report = current_user.reports.build report_params
    if @report.save
      flash[:success] = t ".create_success"
      redirect_to reports_path
    else
      @projects = current_user.valid_projects_by_role
      flash[:danger] = t ".create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    if @report.destroy
      flash[:success] = t ".delete_success"
      redirect_to reports_url
    else
      flash[:danger] = t ".fail_delete"
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  def edit
    @projects = current_user.valid_projects_by_role.by_recently_created
  end

  def update
    if @report.update report_params
      flash.now[:success] = t ".update_success"
    else
      flash.now[:danger] = t ".update_fail"
    end
    respond_to do |format|
      format.html{redirect_to reports_path}
      format.turbo_stream
    end
  end

  private

  def report_params
    params.require(:report).permit Report::UPDATE_ATTRS
  end

  def check_role
    return if current_user.can_edit_delete_report? @report

    flash[:warning] = t ".cannot_delete"
    redirect_to reports_url
  end

  def respond
    respond_to do |format|
      format.html{render :index}
      format.xlsx do
        date = Time.zone.now.strftime Settings.date.format
        header = "attachment; filename=#{date}_reports.xlsx"
        response.headers["Content-Disposition"] = header
      end
    end
  end
end
