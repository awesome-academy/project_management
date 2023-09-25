module ValueResourcesHelper
  def year_field_value params_year
    params_year || Date.current.year
  end

  # convert hash to specific tag
  def value_resource_hash_to_html hash, html_tag
    # flatten all value, resource, diff, total to array
    out = hash.values.map(&:values).flatten
    out = out.each_with_index.map do |ele, i|
      text_class = ""
      if ele.nonzero? && ((i + 1) % 3).zero?
        text_class = ele.negative? ? "text-danger" : "text-primary"
      end
      content_tag html_tag.to_sym, ele, class: text_class
    end
    # EX td tag: <td>ele1</td><td>ele2</td><td></td><td></td>
    safe_join out
  end

  def value_resources_project_html project, start_month_year, end_month_year
    hash_month = ProjectMonthAnalyzer.call(project,
                                           start_month_year, end_month_year)
                                     .result
    value_resource_hash_to_html hash_month, :td
  end

  def value_resources_total_html projects, start_month_year, end_month_year
    hash_month = ProjectsMonthSummaryAnalyzer.call(projects,
                                                   start_month_year,
                                                   end_month_year)
                                             .result
    value_resource_hash_to_html hash_month, :td
  end

  def month_number_displayed start_month_year, end_month_year
    start_date = convert_month_year_to_date start_month_year
    end_date = convert_month_year_to_date end_month_year
    if start_date > end_date ||
       # if start date bigger than current in month and year
       (start_date.end_of_month > Date.current.end_of_month)
      return []
    end

    end_date = Date.current if end_date > Date.current
    (start_date..end_date).map{|d| [d.year, d.month]}.uniq
  end

  def convert_month_year_to_date month_year
    [month_year, "1"].join("-").to_date
  end

  def start_month_field_value month_year_params
    return month_year_params if month_year_params

    date = Date.current.change(month: 1)
    date.strftime Settings.date.format_month_field
  end

  def value_resources_project_xlsx project, year
    hash_month = ProjectMonthAnalyzer.call(project, year).result
    hash_month.values.map(&:values).flatten
  end

  def value_resources_total_xlsx projects, year
    hash_month = ProjectsMonthSummaryAnalyzer.call(projects, year).result
    values_array = hash_month.values.map(&:values).flatten
    values_array.unshift I18n.t("value_resources.index.total")
  end

  def header_row_xlsx year
    header = []
    header << I18n.t("projects.index.name")
    month_number_displayed(year).times do
      header << I18n.t("value_resources.index.value")
      header << I18n.t("value_resources.index.resource")
      header << I18n.t("value_resources.index.diff")
    end
    header << I18n.t("value_resources.index.total_value_year",
                     month: month_number_displayed(year))
    header << I18n.t("value_resources.index.total_resource_year",
                     month: month_number_displayed(year))
    header << I18n.t("value_resources.index.total_diff_year",
                     month: month_number_displayed(year))
  end

  def header_month_xlsx year
    header = [""]
    month_number_displayed(year).times do |i|
      header << "#{I18n.t('project_features.project_feature.month')} #{i + 1}"
      header << nil
      header << nil
    end
    header << I18n.t("value_resources.index.total_year")
  end
end
