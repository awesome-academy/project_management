class AddReleasePlanIdToFeature < ActiveRecord::Migration[7.0]
  def change
    add_column :project_features, :release_plan_id, :bigint
    add_foreign_key :project_features, :release_plans, column: :release_plan_id
  end
end
