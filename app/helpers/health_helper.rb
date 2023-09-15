module HealthHelper
  def status_options
    ProjectHealthItem.statuses.keys.map do |status|
      [t("health.status.#{status}"), status]
    end
  end
end
