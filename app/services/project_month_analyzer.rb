class ProjectMonthAnalyzer < Patterns::Service
  include ValueResourcesHelper

  def initialize project, start_month_year, end_month_year
    @project = project
    @start_month_year = start_month_year
    @end_month_year = end_month_year
  end

  def call
    value_resources_months
  end

  private
  attr_reader :project, :start_month_year, :end_month_year

  # calculator project value, resource, diff per month in year
  def value_resources_months
    # return hash value, resource, diff per month
    hash_out = {}
    value_total = 0
    # [[year, month], [year, month], [year, month], [year, month]]
    month_number_displayed(start_month_year, end_month_year).each do |ele|
      value_total, hash_out[ele.reverse.join "-"] =
        value_resources_month ele, value_total
    end
    hash_out[:total] = value_resources_year hash_out
    # {1: {value, resource, diff}, 2: {value, resource, diff}, ..., diff},
    # total: {value, resource, diff}}
    hash_out
  end

  # calculator project value, resource total in year
  def value_resources_year project_month
    # sum all value 12 month 1 + (1+ 2) + (1 + 2 + 3) ... of project
    project_month_values = project_month.values
    values_total = project_month_values.reduce(0){|a, e| a + e[:value]}
                                       .round(Settings.digits.length_2)
    # sum all resource 12 month 1 + 2 + 3 ... of project
    resources_total = project_month_values.reduce(0){|a, e| a + e[:resource]}
                                          .round(Settings.digits.length_2)
    # diff calculator
    diffs_total = values_total - resources_total
    # hash value type output
    # {total: {value, resource, diff}
    {value: values_total, resource: resources_total,
     diff: diffs_total.round(Settings.digits.length_2)}
  end

  def value_resources_month month_year, value_total
    # sum all value in year form month 1 to current month of project
    # month_year = [year, month]
    value_total += project.project_features
                          .total_man_month_year month_year[1], month_year[0]
    # resource total in month
    resource_total = project.project_user_resources
                            .total_man_month_year month_year[1], month_year[0]
    # hash :month
    hash_month = {value: value_total.round(Settings.digits.length_2),
                  resource: resource_total,
                  diff: (value_total - resource_total)
                 .round(Settings.digits.length_2)}
    [value_total, hash_month]
  end
end
