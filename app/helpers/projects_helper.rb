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
    [["New", 0], ["In Progress", 1], ["Maintaining", 2], ["Pending", 3],
["Close", 4]]
  end
end
