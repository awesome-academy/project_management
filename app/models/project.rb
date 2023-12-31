class Project < ApplicationRecord
  attr_accessor :month_year, :project_id

  PROJECT_PARAMS = [
    :name, :rubato_id, :description, :status,
    :start_date, :end_date, :group_id,
    :language, :repository, :redmine,
    :project_folder, :customers,
    :creator_id,
    {
      project_environments_attributes: [
        :id, :environment, :domain, :port,
        :ip_address, :web_server,
        :note, :_destroy
      ]
    }
  ].freeze

  PROJECT_FEATURE_PARAMS = [
    :month_year, :project_id,
    {
      project_features_attributes:
        [
          :name, :description,
          :waste_description,
          :effort_saved, :repeat_time,
          :repeat_unit, :_destroy
        ]
    }
  ].freeze

  PROJECT_USER_RESOURCES_PARAMS = [
    :id, :month_year,
    {
      project_user_resources_attributes:
        [
          :project_user_id,
          :percentage,
          :_destroy,
          :month,
          :year,
          :id
        ]
    }
  ].freeze

  PROJECT_HEALTH_ITEMS_PARAMS = [
    :id,
    {
      project_health_items_attributes:
        [
          :id,
          :status,
          :_destroy
        ]
    }
  ].freeze

  belongs_to :group
  belongs_to :creator, class_name: User.name

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
  has_many :project_user_resources, through: :project_users
  has_many :lesson_learns, dependent: :destroy
  has_many :project_slack_settings, dependent: :destroy

  delegate :name, to: :group, prefix: true
  delegate :name, to: :creator, prefix: true

  enum status: {new: 0, in_progress: 1, maintaining: 2, pending: 3, close: 4},
       _prefix: true
  accepts_nested_attributes_for :project_environments, allow_destroy: true,
                                                       reject_if: :all_blank
  accepts_nested_attributes_for :project_features, allow_destroy: true,
                                                   reject_if: :all_blank
  accepts_nested_attributes_for :project_users, allow_destroy: true,
                                                   reject_if: :all_blank
  accepts_nested_attributes_for :project_user_resources, allow_destroy: true,
                                                   reject_if: :all_blank
  accepts_nested_attributes_for :project_health_items, allow_destroy: true,
                                                    reject_if: :all_blank

  validates :name, presence: true, uniqueness: true,
                   length: {maximum: Settings.project.max_length_200}
  validates :description, length: {maximum: Settings.project.max_length_1000}
  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :group_id, presence: true
  validates :language, presence: true
  validates :repository, length: {maximum: Settings.project.max_length_200}
  validates :redmine, length: {maximum: Settings.project.max_length_200}
  validates :project_folder, length: {maximum: Settings.project.max_length_200}
  validates :rubato_id, length: {maximum: Settings.project.max_length_100}

  scope :filter_project, lambda {|project_id|
    where id: project_id if project_id.present?
  }
  scope :filter_name, lambda {|name|
    where("projects.name LIKE ?", "%#{name}%") if name.present?
  }
  scope :filter_month_and_year, lambda {|month, year|
    if month && year
      where("EXTRACT(MONTH FROM start_date) = ? \
      AND EXTRACT(YEAR FROM start_date) = ?", month, year)
    end
  }
  scope :filter_status, ->(status){where status: status if status.present?}
  scope :filter_group, lambda {|group_id|
    group = Group.find_by id: group_id
    return if group.nil?

    valid_group_ids = group.nested_sub_group_ids << group_id
    where group_id: valid_group_ids
  }
  scope :filter_features_from, lambda {|from_month, from_year|
    query = joins(:project_features)
    if from_month.present? && from_year.present?
      # if from_year < year in record, then don't need to check month
      query = query.where("project_features.year > ? OR
                                  (project_features.year = ? AND
                                   project_features.month >= ?)",
                          from_year, from_year, from_month)
    end
    query.select(
      "projects.*, project_features.month as month,
         project_features.year as year"
    )
         .distinct
         .order(:year, :month)
  }
  scope :filter_features_to, lambda {|to_month, to_year|
    query = joins(:project_features)
    if to_month.present? && to_year.present?
      # if to_year > year in record, then don't need to check month
      query = query.where("project_features.year < ? OR
                                  (project_features.year = ? AND
                                   project_features.month <= ?)",
                          to_year, to_year, to_month)
    end
    query.select(
      "projects.*, project_features.month as month,
         project_features.year as year"
    )
         .distinct
         .order(:year, :month)
  }
  scope :filter_resources_to, lambda {|to_month, to_year|
    query = joins(:project_user_resources)
    if to_month.present? && to_year.present?
      query = query.where("project_user_resources.year < ? OR
                                  (project_user_resources.year = ? AND
                                   project_user_resources.month <= ?)",
                          to_year, to_year, to_month)
    end
    query.select(
      "projects.*, project_user_resources.month as month,
         project_user_resources.year as year"
    )
         .distinct
         .order(:year, :month)
  }
  scope :filter_resources_from, lambda {|from_month, from_year|
    query = joins(:project_user_resources)
    if from_month.present? && from_year.present?
      query = query.where("project_user_resources.year > ? OR
                                  (project_user_resources.year = ? AND
                                   project_user_resources.month >= ?)",
                          from_year, from_year, from_month)
    end
    query.select(
      "projects.*, project_user_resources.month as month,
         project_user_resources.year as year"
    )
         .distinct
         .order(:year, :month)
  }
  scope :created_by_user_or_psm, lambda {|current_user|
    where(creator_id: current_user.id)
      .or(
        where(
          id: ProjectUser
            .where(
              user_id: current_user.id,
              project_role_id: Role.find_by(name: Settings.project_roles.PSM)
            )
            .select(:project_id)
        )
      )
  }
  scope :user_names_by_project_id, lambda {|project_id|
    joins(project_users: :user)
      .where(id: project_id)
      .select("users.name", "project_users.id")
  }
  scope :without_health_items,
        ->{where.not(id: ProjectHealthItem.distinct.pluck(:project_id))}

  def project_in_health_item
    ProjectHealthItem.distinct.pluck(:project_id)
  end

  def calculate_project_man_per_month date
    year, month = date&.split("-")
    year ||= Time.zone.now.year
    month ||= Time.zone.now.month
    project_features = self.project_features
                           .filter_month(month)
                           .filter_year(year)
    man_month = project_features.reduce(0){|a, e| a + e.calculator_man_month}
    man_month.round Settings.digits.length_2
  end

  def calculate_project_resource_man_per_month month, year
    project_user_resources.total_man_month_year(month, year)
  end

  def can_delete_project?
    reports.empty? &&
      project_user_resources.empty? &&
      project_features.empty? &&
      release_plans.empty?
  end
end
