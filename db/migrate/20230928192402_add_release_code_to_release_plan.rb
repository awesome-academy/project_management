class AddReleaseCodeToReleasePlan < ActiveRecord::Migration[7.0]
  def change
    add_column :release_plans, :release_code, :string, null: true
    add_index :release_plans, [:release_code, :project_id], unique: true
  end
end
