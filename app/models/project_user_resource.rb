class ProjectUserResource < ApplicationRecord
  belongs_to :project_user

  after_rollback do
    errors.full_messages.join(", ")
  end

  before_validation :add_man_month_before_save

  validates :percentage, :month, :year, :man_month,
            presence: true
  validates :project_user_id, uniqueness: {scope: %i(month year),
                                           message: I18n.t(".duplicate_users")}
  validate :total_percentage_within_limit, on: %i(create update)

  scope :filter_project_user_ids, lambda {|project_user_ids|
                                    if project_user_ids
                                      where(project_user_id: project_user_ids)
                                    end
                                  }
  scope :filter_month, ->(month){where(month:) if month}
  scope :filter_year, ->(year){where(year:) if year}
  scope :total_man_month_year, lambda {|month, year|
    filter_month(month).filter_year(year)
                       .sum(:man_month)
                       .round(Settings.digits.length_2)
  }
  scope :total_man_month_projects, lambda {|project_ids, month, year|
    project_user_ids = ProjectUser.where(project_id: project_ids).pluck(:id)
    where(project_user_id: project_user_ids)
      .total_man_month_year(month, year)
      .round(Settings.digits.length_2)
  }
  scope :sorted_by_month_and_year, ->{order(:year, :month)}

  def user_name
    project_user.user.name
  end

  class << self
    def total_all_project_month
      joins(:project_user)
        .select(:project_id, :month, :year)
        .group(:project_id, :month, :year)
        .sum(:man_month)
    end
  end

  private

  def add_man_month_before_save
    self.man_month = percentage / 100.0
  end

  def total_percentage_within_limit
    return unless project_user_id && month && year

    user_id = find_user_id
    total_percentage = calculator_total_percentage user_id

    return unless total_percentage + percentage > 100

    errors.add(:percentage, I18n.t(".error_percentage_limit"))
  end

  def calculator_total_percentage user_id
    total_percentage = ProjectUserResource.joins(project_user: :user)
                                          .where(users: {id: user_id})
                                          .where(
                                            project_user_resources: {
                                              month:,
                                              year:
                                            }
                                          )
                                          .sum(:percentage)
    project_user_resource = ProjectUserResource.where(id:)
    if project_user_resource[0] &&
       project_user_resource[0].project_user_id == project_user_id
      total_percentage -= project_user_resource[0].percentage
    end
    total_percentage
  end

  def find_user_id
    ProjectUser.where(id: project_user_id).pluck(:user_id)&.first
  end
end
