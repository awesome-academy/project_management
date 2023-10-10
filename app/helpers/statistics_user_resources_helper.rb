module StatisticsUserResourcesHelper
  GROUP_LIST = Group.pluck :name, :id
  PROJECT_USER_LIST = ProjectUser.pluck :project_role_id, :id
  ROLE_LIST = Role.pluck :name, :id
  PROJECT_LIST = Project.by_earliest_created.pluck :name, :id
  PROJECT_USER_RESOURCE_LIST = ProjectUserResource.pluck :project_user_id,
                                                         :month, :year,
                                                         :percentage

  def select_ids_from_list list, ids
    list.select{|_item, id| ids.include? id}.map{|item, _id| item}
  end

  def this_year
    Time.zone.now.year
  end

  def list_year
    (this_year - Settings.date.year_range)..this_year
  end

  def list_per_page
    [10, 20, 30, 50]
  end

  def convert_month_to_date month
    ["1", month, "1"].join("-").to_date
  end

  def group_name_from_group_ids group_ids
    select_ids_from_list(GROUP_LIST, group_ids).join(", ")
  end

  def role_name_from_project_user_ids project_user_ids
    role_ids = select_ids_from_list(PROJECT_USER_LIST, project_user_ids)
    select_ids_from_list(ROLE_LIST, role_ids).join(", ")
  end

  def project_name_from_project_ids project_ids
    select_ids_from_list(PROJECT_LIST, project_ids).join(", ")
  end

  def resources_from_project_users_by_month project_user_ids, month, year
    ProjectUserResource.filter_project_user_ids(project_user_ids)
                       .filter_month(month)
                       .filter_year(year).sum(:percentage)
  end

  def detail_from_project_users_by_month project_user_ids, month, _year
    project_user_ids.map do |project_user_id|
      project_user_name = ProjectUser.find_by(id: project_user_id).project_name
      resources = ProjectUserResource.find_by(project_user_id:,
                                              month:)&.percentage
      "#{project_user_name}: #{resources}%" if resources
    end.compact.join(", ")
  end

  def header_excel
    header = []
    header << t("statistics_user_resources.table.name")
    header << t("statistics_user_resources.table.group")
    header << t("statistics_user_resources.table.role")
    header << t("statistics_user_resources.table.project")
    12.times do |i|
      header << l(convert_month_to_date(i + 1),
                  format: Settings.date.format_short_month)
      header << t("statistics_user_resources.table.detail")
    end
    header
  end

  def data_excel user
    row = []
    row << user.name
    row << group_name_from_group_ids(user.group_ids)
    row << role_name_from_project_user_ids(user.project_user_ids)
    row << project_name_from_project_ids(user.project_ids)
    row << month_details(user)
    row
  end

  def month_details user
    row = []
    12.times do |i|
      row << resources_from_project_users_by_month(user.project_user_ids, i + 1)
      row << detail_from_project_users_by_month(user.project_user_ids, i + 1)
    end
    row
  end
end
