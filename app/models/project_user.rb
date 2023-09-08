class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :project_role, class_name: Role.name
  has_many :project_user_resources, dependent: :destroy

  PROJECT_USER_PARAMS = [
    :project_id, :user_id, :project_role_id, :joined_at,
    :left_at,
    {
      project_user_resources_attributes: [
        :project_user_id, :percentage, :month,
        :year, :man_month, :_destroy
      ]
    }
  ].freeze

  delegate :name, :git_account, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :project_role, prefix: true, allow_nil: true

  scope :by_earliest_joined, ->{order :joined_at}
  accepts_nested_attributes_for :project_user_resources, allow_destroy: true,
  reject_if: :all_blank

  validates :project_id, presence: true
  validates :user_id, presence: true
  validates :project_role_id, presence: true
end
