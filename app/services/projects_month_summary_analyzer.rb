class ProjectsMonthSummaryAnalyzer < Patterns::Service
  include ValueResourcesHelper

  def initialize projects, year
    @projects = projects
    @year = year
  end

  def call
    value_resources_months_total
  end

  private
  attr_reader :projects, :year

  # calculator total value, resource, diff of all projects
  def value_resources_months_total
    project_ids = projects.pluck(:id)
    hash_out = {}
    value_total = 0
    month_number_displayed(year).times do |i|
      month = i + 1
      value_total, hash_out[month] = value_resources_month_total month,
                                                                 value_total,
                                                                 project_ids
    end
    hash_out[:total] = value_resources_year_total hash_out
    # {1: {value, resource, diff}, 2: {value, resource, diff}, ..., diff},
    # total: {value, resource, diff}}
    hash_out
  end

  # calculator total of list projects
  def value_resources_year_total projects_month
    # sum all values 12 month 1 + (1+ 2) + (1 + 2 + 3) ... of list projects
    projects_month_values = projects_month.values
    values_total = projects_month_values.reduce(0){|a, e| a + e[:value]}
                                        .round(Settings.digits.length_2)
    # sum all resources 12 month 1 + 2 + 3 ... of list projects
    resources_total = projects_month_values.reduce(0){|a, e| a + e[:resource]}
                                           .round(Settings.digits.length_2)
    # diff calculator
    diffs_total = (values_total - resources_total)
                  .round(Settings.digits.length_2)

    # hash value type output
    # {total: {value, resource, diff}
    {value: values_total, resource: resources_total,
     diff: diffs_total}
  end

  def value_resources_month_total month, value_total, project_ids
    # sum all value in year form month 1 to current month of list projects
    value_total += ProjectFeature
                   .total_man_month_projects project_ids, month, year
    # resource total in month of list projects
    resource_total = ProjectUserResource
                     .total_man_month_projects project_ids, month, year
    # # hash :month
    hash_month = {value: value_total.round(Settings.digits.length_2),
                  resource: resource_total,
                  diff: (value_total - resource_total)
                 .round(Settings.digits.length_2)}
    [value_total, hash_month]
  end
end