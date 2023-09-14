class ProjectUserResource < ApplicationRecord
  belongs_to :project_user

  validates :percentage, :month, :year, :man_month,
            presence: true

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

  def user_name
    project_user.user.name
  end
end
