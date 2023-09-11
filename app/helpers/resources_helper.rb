module ResourcesHelper
  include FormHelper
  include SessionsHelper

  def list_members project_id
    return [] if project_id.nil?

    project = Project.find_by id: project_id
    return [] if project.nil?

    project.users.map{|user| [user.name, user.id]}
  end
end
