module ProjectsHelper
  def list_group
    Group.pluck :name, :id
  end

  def list_statuses
    Project.statuses.map do |key, value|
      [t("projects.project.#{key}"), value]
    end
  end

  def status_select
    Project.statuses.keys.map do |status|
      [t("project.form.status.#{status}"), status]
    end
  end

  def environment_select
    ProjectEnvironment.environments.keys.map do |environment|
      [t("project.form.environment.#{environment}"), environment]
    end
  end

  def customer_info_select
    Customer.all.pluck :name, :id
  end

  def group_select
    Group.all.pluck :name, :id
  end

  def project_health_status_name status
    status_i_class = {not_apply: "bi bi-x-circle text-danger",
                      apply_no_full_update: "bi bi-dash-circle text-warning",
                      apply_and_full_update: "bi bi-check-circle text-success"}
    out = Array.new
    out << content_tag(:i, "", class: status_i_class[status.to_sym])
    out << content_tag(:span, t("health.status.#{status}"), class: "ms-1")
    safe_join(out)
  end

  def environment_name_class environment
    environment_names = {staging: "primary",
                         production: "success"}
    environment_names[environment.to_sym]
  end

  def page_tab?
    params[:page].present?
  end

  def list_customer customers
    return t "projects.project_detail.dont_have_customer" if customers.empty?

    list_customer = []
    customers.each do |ctm|
      list_customer << content_tag(:p, ctm.name, class: "mb-2")
    end
    safe_join list_customer
  end

  def project_select
    if current_user.admin? || current_user.manager?
      return Project.pluck(:name, :id)
    end

    Project.created_by_user_or_psm(current_user).pluck(:name, :id)
  end

  def list_project_user project_id
    Project.user_names_by_project_id(project_id)
           .map{|user| [user.name, user.id]}
  end
end
