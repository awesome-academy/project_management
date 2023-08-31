class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :reports, dependent: :destroy
  has_many :project_customers, dependent: :destroy
  has_many :customers, through: :project_customers
  has_many :release_plans, dependent: :destroy
  has_many :project_environments, dependent: :destroy
  has_many :project_features, dependent: :destroy
  has_many :project_health_items, dependent: :destroy
  has_many :health_items, through: :project_health_items
  belongs_to :group

  enum status: {news: 0, in_progress: 1, maintaining: 2, pending: 3, close: 4}

  scope :filter_name, lambda {|name|
    where("name LIKE ?", "%#{name}%") if name.present?
  }
  scope :filter_date, ->(date){filter_by_date(date) if date.present?}
  scope :filter_status, ->(status){where status: status if status.present?}
  scope :filter_group, ->(group){where group_id: group if group.present?}

  class << self
    def filter_by_date date_str
      date = valid_date date_str
      date.present? ? where(start_date: date) : all
    end

    def valid_date date_str
      Date.parse date_str
    rescue ArgumentError
      nil
    end
  end
end
