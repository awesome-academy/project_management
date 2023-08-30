require "csv"
namespace :import do
  desc "Get csv data from csv file"
  task user: :environment do
    import_file = Rails.root.join("db/master_data/users.csv")
    users = []
    user_groups = []
    max_id = User.maximum(:id).nil? ? 1 : User.maximum(:id) + 1
    CSV.foreach(import_file, headers: true) do |row|
      row_data = row.to_h
      group = import_group row_data["group_name"]
      user = User.find_by email: row_data["email"]
      if user.nil?
        user = user_params max_id, row_data["name"], row_data["email"],
                           row_data["slack_id"], row_data["git_account"]
        users << user.attributes
        user_groups << UserGroup.new(group_id: group.id, user_id: user.id)
                                .attributes
        max_id += 1
      elsif UserGroup.find_by(group_id: group.id, user_id: user.id).nil?
        user_groups << UserGroup.new(group_id: group.id, user_id: user.id)
                                .attributes
      end
    end
    User.insert_all users
    UserGroup.insert_all user_groups
  end
end

def import_group group_string
  group = Group.find_by name: group_string
  if group.nil?
    group_arr = group_string.split("/")
    parent_group_id = nil
    group_arr.each do |group_name|
      group = Group.find_by name: group_name
      if group.nil?
        group = Group.create! name: group_name, parent_id: parent_group_id
      end
      parent_group_id = group.id
    end
  end
  group
end

def user_params id, name, email, slack_id, git_account
  User.new(
    id:,
    name:,
    email:,
    password: "123456",
    password_confirmation: "123456",
    avatar: "https://toplist.vn/images/800px/dao-phu-quoc-15999.jpg",
    remember_token: SecureRandom.urlsafe_base64,
    slack_id:,
    git_account:,
    created_at: Time.zone.now,
    updated_at: Time.zone.now
  )
end
