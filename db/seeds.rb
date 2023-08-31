User.create!(
  name: "User Sun*",
  email: "usersun@gmail.com",
  password: "aaaaaa",
  password_confirmation: "aaaaaa",
  avatar: "https://toplist.vn/images/800px/dao-phu-quoc-15999.jpg",
  remember_token: SecureRandom.urlsafe_base64
)
User.create!(
  name: "Manage Sun*",
  email: "managesun@gmail.com",
  password: "aaaaaa",
  password_confirmation: "aaaaaa",
  avatar: "https://toplist.vn/images/800px/dao-phu-quoc-15999.jpg",
  remember_token: SecureRandom.urlsafe_base64
)
User.create!(
  name: "Admin Sun*",
  email: "adminsun@gmail.com",
  password: "aaaaaa",
  password_confirmation: "aaaaaa",
  avatar: "https://toplist.vn/images/800px/dao-phu-quoc-15999.jpg",
  remember_token: SecureRandom.urlsafe_base64
)
50.times do |i|
  User.create!(
    name: Faker::Name.name,
    email: "#{Faker::Name.first_name}@gmail.com",
    password: "aaaaaa",
    password_confirmation: "aaaaaa",
    avatar: "https://toplist.vn/images/800px/dao-phu-quoc-15999.jpg",
    remember_token: SecureRandom.urlsafe_base64
  )
end


user_role_arr = ["user", "manager", "admin"]
user_role_arr.each do |role|
  Role.create!(
    name: role,
    description: Faker::Lorem.sentence,
    role_type: 1
  )
end
project_role_arr = ["QA", "QA leader", "Developer", "Comtor", "BrSE", "PSM", "Team leader", "Unit Manager", "Designer", "Infra"]
project_role_arr.each do |role|
  Role.create!(
    name: role,
    description: Faker::Lorem.sentence,
    role_type: 0
  )
end

10.times do |i|
  Group.create!(
    name: "Group number #{i}",
    description: Faker::Lorem.sentence
  )
end

languages = ["ruby", "Javascript", "Python", "Java", "C#"]
10.times do |i|
  Project.create!(
    group_id: Faker::Number.between(from: 1, to: 10),
    name: "Project number #{i}",
    description: Faker::Lorem.sentence,
    status: Faker::Number.between(from: 0, to: 3),
    language: languages[Faker::Number.between(from: 0, to: 4)],
    start_date: Faker::Date.between(from: 6.months.ago, to: 2.months.ago),
    end_date: Faker::Date.between(from: 2.months.from_now, to: 1.year.from_now)
  )
end

groups = Group.all
users = User.all
100.times do |i|
  UserGroup.create!(
    group_id: Faker::Number.between(from: 1, to: groups.size),
    user_id: Faker::Number.between(from: 1, to: users.size)
  )
end
users.each do |user|
  if user.id == 2
    role_id = 2
  elsif user.id == 3
    role_id = 3
  else
    role_id = 1
  end
  RoleUser.create!(
    user_id: user.id,
    role_id: role_id
  )
end
projects = Project.all
projects.each do |project|
  10.times do |i|
    ProjectUser.create!(
      project_id: project.id,
      user_id: Faker::Number.between(from: 1, to: users.size),
      project_role_id: Faker::Number.between(from: 4, to: 13)
    )
  end
end

health_item_arr = ["Member info document", "Guideline for new member document", "Apply GKC", "Apply CI",
                   "Apply CD", "Apply Basic authen", "Requirement document", "API design document",
                   "Database design document", "Device management document", "Release checklist", "Final inspection checklist"]
health_item_arr.each do |item|
  HealthItem.create!(
    item: item,
    description: Faker::Lorem.sentence,
    is_enabled: true
  )
end

customer_arr = ["FCOV - Sun*", "other company"]
customer_arr.each do |customer|
  Customer.create!(
    name: customer,
    description: Faker::Lorem.sentence
  )
end
