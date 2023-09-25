module DashboardHelper
  def value_resources_total_chart projects, start_month_year, end_month_year
    hash_month = ProjectsMonthSummaryAnalyzer.call(projects, start_month_year,
                                                   end_month_year).result
    # not use total in chart
    hash_month.delete(:total)
    values = {}
    resources = {}
    diffs = {}
    hash_month.each do |key, value|
      month_string = key
      values[month_string] = value[:value]
      resources[month_string] = value[:resource]
      diffs[month_string] = value[:diff]
    end
    # chart array data
    [{name: t("value_resources.index.value"), data: values},
     {name: t("value_resources.index.resource"), data: resources},
     {name: t("value_resources.index.diff"), data: diffs}]
  end

  def project_statistics_by_status projects
    project_total = projects.count
    Project.statuses.map do |key, value|
      status_count = projects.where(status: key).count
      ratio = status_count / project_total.to_f
      percentage = (ratio *  100).round(Settings.digits.length_2)
      {key:, value:,
       percentage:,
       count: status_count}
    end
  end

  def value_resources_total projects, start_month_year, end_month_year
    hash_month = ProjectsMonthSummaryAnalyzer.call(projects, start_month_year,
                                                   end_month_year).result
    hash_month[:total]
  end

  def dashboard_card_color name, value
    name = name.to_sym
    hash_color = {value: "success", resource: "warning",
                  diff_positive: "primary", diff_negative: "danger"}
    return hash_color[name] if hash_color.key? name

    value.positive? ? hash_color[:diff_positive] : hash_color[:diff_negative]
  end
end
