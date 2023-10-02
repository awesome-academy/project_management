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
    email: "user#{i}@gmail.com",
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

12.times do |i|
  Group.create!(
    name: "Group number #{i}",
    description: Faker::Lorem.sentence,
    parent_id: i == 0 ? nil : Faker::Number.between(from: 1, to: i)
  )
end

languages = ["ruby", "Javascript", "Python", "Java", "C#"]
12.times do |i|
  Project.create!(
    group_id: Faker::Number.between(from: 1, to: 10),
    creator_id: Faker::Number.between(from: 1, to: 3),
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
  # make sure user_id is unique in project
  project_users = []
  11.times do |i|
    user_id = nil
    loop do
      user_id = Faker::Number.between(from: 1, to: users.size)
      break unless project_users.include? user_id
    end
    project_users << user_id
    ProjectUser.create!(
      project_id: project.id,
      user_id: user_id,
      project_role_id: Faker::Number.between(from: 4, to: 13)
    )
  end
end

12.times do |i|
  Report.create!(
      project_id: Faker::Number.between(from: 1, to: projects.size),
      user_id: Faker::Number.between(from: 1, to: users.size),
      description: Faker::Lorem.sentence,
      resource_description: Faker::Lorem.sentence,
      issue: Faker::Lorem.sentence,
      date: Faker::Date.between(from: 6.months.ago, to: 2.months.ago)
  )
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

release_status = ["released", "preparing"]
12.times do |i|
  status = release_status[Faker::Number.between(from: 0, to: 1)]
  released_at = nil
  released_at = Faker::Date.between(from: 6.months.ago, to: 2.months.ago) if status == Settings.is_released.released
  ReleasePlan.create!(
    project_id: Faker::Number.between(from: 1, to: 5),
    creator_id: Faker::Number.between(from: 1, to:3),
    description: Faker::Lorem.sentence,
    is_released: status,
    release_date: Faker::Date.between(from: 6.months.ago, to: 2.months.ago),
    released_at: released_at,
    release_code: "release #{i}"
  )
end

10.times do |i|
  ProjectCustomer.create!(
    project_id: Faker::Number.between(from: 1, to: 5),
    customer_id: Faker::Number.between(from: 1, to: 2)
  )
end

20.times do |i|
  project_id = Faker::Number.between(from: 1, to: projects.size)
  release_plans = ReleasePlan.filter_project(project_id).filter_status(Settings.is_released.released);
  next if release_plans.size == 0
  release_plan_id = release_plans[Faker::Number.between(from: 0, to: release_plans.size - 1)].id
  ProjectFeature.create!(
    project_id: project_id,
    name: Faker::Name.name,
    description: Faker::Lorem.sentence,
    month: Faker::Number.between(from: 1, to: 12),
    year: Faker::Number.between(from: 2023, to: 2024),
    waste_description: Faker::Lorem.sentence,
    effort_saved: Faker::Number.between(from: 1, to: 10),
    repeat_time: Faker::Number.between(from: 1, to: 10),
    repeat_unit: Faker::Number.between(from: 0, to: 5),
    man_month: Faker::Number.between(from: 0, to: 5),
    release_plan_id: release_plan_id
  )
end

5.times do |i|
  ProjectUserResource.create!(
    project_user_id: Faker::Number.between(from: 1, to: 10),
    percentage: Faker::Number.between(from: 1, to: 30),
    month: Faker::Number.between(from: 1, to: 12),
    year: Faker::Number.between(from: 2023, to: 2024),
    man_month: Faker::Number.between(from: 0, to: 5),
    )
end

lesson_learn_category_names = ["Requirement", "Design", "Coding & unit test", "Deploy",
                               "Testing", "Project Management", "User acceptance test",
                               "Other"]
lesson_learn_category_names.each do |item|
  LessonLearnCategory.create!(
    name: item,
  )
end

12.times do |i|
  LessonLearn.create!(
    lesson_learn_category_id: Faker::Number.between(from: 1,
                                                      to: lesson_learn_category_names.length),
    context_description: Faker::Lorem.sentence(word_count: 100),
    learning_point: Faker::Lorem.sentence(word_count: 100),
    reference_process: Faker::Lorem.sentence(word_count: 100),
    creator_id: Faker::Number.between(from: 1, to: 3),
    project_id: Faker::Number.between(from: 1, to: 5),
  )
end
