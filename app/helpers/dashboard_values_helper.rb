module DashboardValuesHelper
  def value_project project, start_month_year, end_month_year
    hash_month = ProjectMonthAnalyzer.call(project, start_month_year,
                                           end_month_year).result
    hash = {}
    hash_month.each do |key, value|
      hash[key] = value[:value]
    end
    {name: project.name, data: hash}
  end

  def values_chart projects, start_month_year, end_month_year
    projects.map do |project|
      value_project(project, start_month_year, end_month_year)
    end
  end
end
