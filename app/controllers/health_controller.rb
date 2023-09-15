class HealthController < ApplicationController
  before_action :logged_in_user, :check_permission, only: %i(new create)

  def new
    @health_items = HealthItem.enable_items
  end

  def create
    create_project_health_items
    flash[:success] = t(".create_success")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".create_fail")
  ensure
    redirect_to resources_path
  end

  private
  def create_project_health_items
    params.require(:project_id)
    params.require(:health_items)

    ActiveRecord::Base.transaction do
      params[:health_items].each do |element|
        next if element[1].empty?

        note = element[1]
        attrs = {project_id: params[:project_id], health_item_id: element[0],
                 note:, status: ProjectHealthItem.statuses[note]}
        item = ProjectHealthItem.new attrs
        item.save!
      end
    end
  end

  def check_permission
    current_user.manager?
  end
end
