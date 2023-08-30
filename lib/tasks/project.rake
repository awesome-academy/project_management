require "csv"
namespace :import do
  desc "Get csv data from csv file"
  task project: :environment do
    import_file = Rails.root.join("db/master_data/projects.csv")
    projects = []
    CSV.foreach(import_file, headers: true) do |row|
      row_data = row.to_h
      group = Group.find_by name: row_data["group_name"].split("/").last
      next if group.nil?

      project = Project.new(
        name: row_data["name"],
        group_id: group.id,
        status: row_data["status"],
        language: row_data["language"],
        start_date: row_data["start_date"].to_date,
        end_date: row_data["end_date"].to_date,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      )
      projects << project.attributes
    end
    Project.insert_all projects
  end
end
