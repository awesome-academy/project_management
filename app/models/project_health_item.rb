class ProjectHealthItem < ApplicationRecord
  belongs_to :project
  belongs_to :health_item

  enum status: {not_apply: 0, apply_no_full_update: 1,
                apply_and_full_update: 2},
       _prefix: true
end
