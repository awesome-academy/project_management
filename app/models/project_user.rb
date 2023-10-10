class ProjectUser < ApplicationRecord
  UPDATE_ATTRS = %i(project_id user_id project_role_id joined_at left_at note)
                 .freeze
  belongs_to :user
  belongs_to :project
  has_many :user_groups, through: :user
  belongs_to :project_role, class_name: Role.name
  has_many :project_user_resources, dependent: :destroy

  delegate :name, :git_account, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :project_role, prefix: true, allow_nil: true
  delegate :name, to: :project, prefix: true, allow_nil: true

  accepts_nested_attributes_for :project_user_resources, allow_destroy: true,
                                                   reject_if: :all_blank

  scope :by_recently_joined, ->{order(joined_at: :desc)}
  scope :id_have_user_roles, lambda {|role_name|
    role = Role.find_by name: role_name
    role_id = role&.id
    where(project_role_id: role_id).pluck(:project_id)
  }
  validates :user_id, uniqueness: {
    scope: :project_id,
    message: I18n.t("project_user.unique_user_in_project")
  }
  validate :validate_dates

  def group_name_text
    groups_name = user_groups.map(&:group_name)
    groups_name.join(",\n")
  end

  private

  def validate_dates
    return unless joined_at.present? && left_at.present?

    return unless joined_at >= left_at

    errors.add(:joined_at, I18n.t("project_user.validate_dates"))
  end
end
