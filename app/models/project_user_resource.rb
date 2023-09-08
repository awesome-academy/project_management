class ProjectUserResource < ApplicationRecord
  belongs_to :project_user
  validates :project_user_id, presence: true
  validates :percentage, presence: true
  validates :month, presence: true
  validates :year, presence: true
  validates :man_month, presence: true
end
