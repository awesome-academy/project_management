class ProjectFeature < ApplicationRecord
  PROJECT_FEATURE_PARAMS = [
    :name, :description, :month,
    :year, :date, :waste_description,
    :effort_saved, :repeat_time,
    :repeat_unit, :release_plan_id
  ].freeze

  belongs_to :project
  belongs_to :release_plan

  delegate :name, to: :project, prefix: true

  enum repeat_unit: {day: 0, week: 1, month: 2, quarter: 3, half_a_year: 4,
                     year: 5}, _prefix: true

  validates :name, presence: true,
            length: {maximum: Settings.digits.length_200}
  validates :description, presence: true,
            length: {maximum: Settings.digits.length_1000}
  validates :month, presence: true
  validates :year, presence: true
  validates :waste_description, presence: true,
            length: {maximum: Settings.digits.length_1000}
  validates :effort_saved, presence: true
  validates :repeat_time, presence: true
  validates :repeat_unit, presence: true, inclusion: {in: repeat_units.keys}
  validates :man_month, presence: true
  validates :release_plan_id, presence: true
  validate :valid_month?, :valid_year?, :valid_release_plan?

  before_validation :add_man_month_before_save

  scope :filter_month, ->(month){where(month:) if month}
  scope :filter_year, ->(year){where(year:) if year}
  scope :filter_project_id, lambda {|project_id|
    where(project_id:) if project_id.present?
  }
  scope :filter_name, lambda {|name|
    includes(:project)
    if name.present?
      joins(:project)
        .where("projects.name LIKE ?", "%#{name}%")
    end
  }
  scope :filter_group, lambda {|group_id|
    group = Group.find_by id: group_id
    return if group.nil?

    valid_group_ids = group.nested_sub_group_ids << group_id
    includes(:project)
    joins(:project).where(projects: {group_id: valid_group_ids})
  }
  scope :group_project_month_year,
        ->{select(:project_id, :month, :year).group(:project_id, :month, :year)}

  scope :total_man_month_year, lambda {|month, year|
    filter_month(month).filter_year(year).sum(:man_month)
                       .round(Settings.digits.length_2)
  }

  scope :total_man_month_projects, lambda {|project_ids, month, year|
    where(project_id: project_ids).total_man_month_year(month, year)
                                  .round(Settings.digits.length_2)
  }
  scope :order_by_month_year, ->{order(:month, :year)}

  def effort_hour_month_save
    return unless effort_saved && repeat_time

    total_hour = effort_saved * repeat_time
    case repeat_unit.to_sym
    when :day then total_hour * 22
    when :week then total_hour * 4
    when :month then total_hour
    when :quarter then total_hour / 4
    when :half_a_year then total_hour / 6
    when :year then total_hour / 12
    else 0 end
  end

  def calculator_man_month
    return unless effort_hour_month_save

    (effort_hour_month_save / (22 * 8))
      .round(Settings.digits.length_2)
  end

  private
  def add_man_month_before_save
    self.man_month = calculator_man_month
  end

  def valid_month?
    unless Date.valid_date? Time.zone.now.year, month, Settings.digits.length_1
      errors.add :month, I18n.t("validates.errors.month")
    end
  end

  def valid_year?
    unless Date.valid_date? year, Time.zone.now.month, Settings.digits.length_1
      errors.add :month, I18n.t("validates.errors.year")
    end
  end

  def valid_release_plan?
    release_plan = ReleasePlan.find_by id: release_plan_id
    return if release_plan&.project_id == project_id

    errors.add :release_plan_id, I18n.t("validates.errors.release_plan_id")
  end
end
