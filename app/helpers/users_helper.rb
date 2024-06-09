module UsersHelper
  def list_group
    Group.pluck :name, :id
  end
end
