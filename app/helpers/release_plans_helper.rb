module ReleasePlansHelper
  def list_status
    ReleasePlan.is_releaseds.keys.map do |key|
      [t("release_plans.is_released.#{key}"), key]
    end
  end

  def can_edit_delete_release_plan release_plan
    current_user.can_edit_delete_release_plan? release_plan
  end

  def list_plan_released project_id
    ReleasePlan.filter_project(project_id)
               .filter_status(Settings.is_released.released)
               .pluck :release_code, :id
  end
end
