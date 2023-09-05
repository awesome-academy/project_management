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

  enum status: {new: 0, in_progress: 1, maintaining: 2, pending: 3, close: 4}

  scope :filter_name, lambda {|name|
                        name.present? ? where("name LIKE ?", "%#{name}%") : all
                      }
  scope :filled_in, ->{includes(:reports).where.not(reports: {id: nil})}
  scope :filter_date, ->(date){date.present? ? filter_by_date(date) : all}

  def self.filter_by_date date_str
    date = valid_date(date_str)
    date.present? ? where(start_date: date) : all
  end

  def self.valid_date date_str
    Date.parse(date_str)
  rescue ArgumentError
    nil
  end
end
