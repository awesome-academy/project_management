# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_29_052639) do
  create_table "customers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
  end

  create_table "groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "parent_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "health_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item", null: false
    t.text "description"
    t.boolean "is_enabled", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lesson_learn_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lesson_learns", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "lesson_learn_category_id", null: false
    t.text "context_description", null: false
    t.text "learning_point", null: false
    t.text "reference_link"
    t.text "reference_process"
    t.bigint "creator_id", null: false
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_lesson_learns_on_creator_id"
    t.index ["lesson_learn_category_id"], name: "index_lesson_learns_on_lesson_learn_category_id"
    t.index ["project_id"], name: "index_lesson_learns_on_project_id"
  end

  create_table "permission_roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "permission_id", null: false
    t.bigint "role_id", null: false
    t.index ["permission_id"], name: "index_permission_roles_on_permission_id"
    t.index ["role_id"], name: "index_permission_roles_on_role_id"
  end

  create_table "permissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "permission_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_customers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "project_id", null: false
    t.index ["customer_id"], name: "index_project_customers_on_customer_id"
    t.index ["project_id"], name: "index_project_customers_on_project_id"
  end

  create_table "project_environments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.integer "environment", null: false
    t.string "ip_address", null: false
    t.integer "port", null: false
    t.string "domain"
    t.string "web_server"
    t.text "note"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_environments_on_project_id"
  end

  create_table "project_features", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "month", null: false
    t.integer "year", null: false
    t.text "waste_description"
    t.float "effort_saved", null: false
    t.float "repeat_time", null: false
    t.integer "repeat_unit", null: false
    t.float "man_month", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "release_plan_id"
    t.index ["project_id"], name: "index_project_features_on_project_id"
    t.index ["release_plan_id"], name: "fk_rails_93dfdcbd5c"
  end

  create_table "project_health_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "health_item_id", null: false
    t.text "note"
    t.integer "status", null: false
    t.datetime "deleted_at"
    t.index ["health_item_id"], name: "index_project_health_items_on_health_item_id"
    t.index ["project_id"], name: "index_project_health_items_on_project_id"
  end

  create_table "project_slack_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "slack_room"
    t.string "slack_mention"
    t.boolean "send_release", default: false
    t.boolean "send_value", default: false
    t.boolean "send_resource", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_slack_settings_on_project_id"
  end

  create_table "project_user_resources", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_user_id", null: false
    t.integer "percentage", null: false
    t.integer "month", null: false
    t.integer "year", null: false
    t.float "man_month", null: false
    t.index ["project_user_id", "month", "year"], name: "idx_pur_on_pu_month_year", unique: true
    t.index ["project_user_id"], name: "index_project_user_resources_on_project_user_id"
  end

  create_table "project_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.bigint "project_role_id", null: false
    t.datetime "joined_at"
    t.datetime "left_at"
    t.text "note"
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["project_role_id"], name: "index_project_users_on_project_role_id"
    t.index ["user_id", "project_id"], name: "index_project_users_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "creator_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "status", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "repository"
    t.text "redmine"
    t.text "project_folder"
    t.string "language", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rubato_id"
    t.index ["creator_id"], name: "index_projects_on_creator_id"
    t.index ["group_id"], name: "index_projects_on_group_id"
    t.index ["name"], name: "index_projects_on_name", unique: true
  end

  create_table "release_plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "creator_id", null: false
    t.text "description"
    t.boolean "is_released", null: false
    t.datetime "release_date"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "released_at"
    t.string "release_code"
    t.index ["creator_id"], name: "index_release_plans_on_creator_id"
    t.index ["project_id"], name: "index_release_plans_on_project_id"
    t.index ["release_code", "project_id"], name: "index_release_plans_on_release_code_and_project_id", unique: true
  end

  create_table "reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "date", null: false
    t.text "description", null: false
    t.text "resource_description", null: false
    t.text "issue", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_reports_on_project_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "role_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.index ["role_id"], name: "index_role_users_on_role_id"
    t.index ["user_id"], name: "index_role_users_on_user_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "role_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "avatar", null: false
    t.string "remember_digest"
    t.string "slack_id"
    t.string "git_account"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "lesson_learns", "lesson_learn_categories"
  add_foreign_key "lesson_learns", "projects"
  add_foreign_key "lesson_learns", "users", column: "creator_id"
  add_foreign_key "permission_roles", "permissions"
  add_foreign_key "permission_roles", "roles"
  add_foreign_key "project_customers", "customers"
  add_foreign_key "project_customers", "projects"
  add_foreign_key "project_environments", "projects"
  add_foreign_key "project_features", "projects"
  add_foreign_key "project_features", "release_plans"
  add_foreign_key "project_health_items", "health_items"
  add_foreign_key "project_health_items", "projects"
  add_foreign_key "project_slack_settings", "projects"
  add_foreign_key "project_user_resources", "project_users"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "roles", column: "project_role_id"
  add_foreign_key "project_users", "users"
  add_foreign_key "projects", "groups"
  add_foreign_key "projects", "users", column: "creator_id"
  add_foreign_key "release_plans", "projects"
  add_foreign_key "release_plans", "users", column: "creator_id"
  add_foreign_key "reports", "projects"
  add_foreign_key "reports", "users"
  add_foreign_key "role_users", "roles"
  add_foreign_key "role_users", "users"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
end
