module ProjectsHelper
  def format_date date
    date.strftime("%d/%m/%Y")
  end

  def group_name project
    project.group.name
  end

  def list_group
    Group.pluck :name, :id
  end

  def list_status
    Project.statuses.map do |key, value|
      [t("projects.project.#{key}"), value]
    end
  end
end
