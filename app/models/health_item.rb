class HealthItem < ApplicationRecord
  has_many :project_health_items, dependent: :destroy
  has_many :projects, through: :project_health_items
  scope :enable_items, ->{where is_enabled: true}
end
