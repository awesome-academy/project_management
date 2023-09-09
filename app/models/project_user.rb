class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :project_role, class_name: Role.name
  has_many :project_user_resources, dependent: :destroy

  delegate :name, :git_account, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :project_role, prefix: true, allow_nil: true

  scope :by_earliest_joined, ->{order :joined_at}
  scope :id_have_user_roles, lambda {|role_name|
    role = Role.find_by name: role_name
    role_id = role&.id
    where(project_role_id: role_id).pluck(:project_id)
  }

  accepts_nested_attributes_for :project_user_resources, allow_destroy: true,
    reject_if: :all_blank
end
