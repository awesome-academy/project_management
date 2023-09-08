module ResourcesHelper
  include FormHelper

  def list_projects
    Project.pluck :name, :id
  end

  def list_members project_id
    if project_id.present?
      project = Project.find(project_id)
      return members = project.users || []
    else
      []
    end
  end
end
