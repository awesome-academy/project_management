class Report < ApplicationRecord
  UPDATE_ATTRS = [
    :date, :description,
    :resource_description, :issue
  ].freeze

  belongs_to :project
  belongs_to :user

  delegate :name, to: :project, prefix: true
  delegate :name, :email, to: :user, prefix: true

  validates :date, presence: true
  validates :project_id, presence: true
  validates :description, presence: true,
            length: {maximum: Settings.project.max_length_1000}
  validates :resource_description, presence: true,
            length: {maximum: Settings.project.max_length_1000}
  validates :issue, presence: true,
            length: {maximum: Settings.project.max_length_1000}

  scope :filter_name_status, lambda {|name, status|
    ids = Project.filter_name(name)
                 .filter_status(status).pluck :id
    where(project_id: ids)
  }
end
