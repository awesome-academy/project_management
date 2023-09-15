module ProjectUsersHelper
  def list_roles
    Role.project_role.pluck :name, :id
  end

  def list_users
    User.pluck :name, :id
  end
end
