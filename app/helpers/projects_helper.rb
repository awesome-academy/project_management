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
    status_names = {1 => {message: I18n.t("status_1"),
                          i_class: "bi bi-x-circle text-danger"},
                    2 => {message: I18n.t("status_2"),
                          i_class: "bi bi-dash-circle text-warning"},
                    3 => {message: I18n.t("status_3"),
                          i_class: "bi bi-check-circle text-success"}}
    status_name = status_names[status]
    out = Array.new
    out << content_tag(:i, "", class: status_name[:i_class])
    out << content_tag(:span, status_name[:message], class: "ms-1")
    safe_join(out)
  end

  def environment_name environment
    environment_names = {staging: {message: I18n.t("environment_0"),
                                   type: "danger"},
                         production: {message: I18n.t("environment_１"),
                                      type: "info"}}
    environment_name = environment_names[environment.to_sym]
    content_tag(:p, environment_name[:message],
                class: "f-n-hover btn btn-#{environment_name[:type]} btn-raised
                        px-4 py-25 w-75 text-600")
  end

  def page_tab?
    params[:page].present?
  end

  def project_member_stt project, project_user
    project.project_users.index(project_user) + 1
  end

  def list_customer customers
    return t "projects.project_detail.dont_have_customer" if customers.empty?

    list_customer = []
    customers.each do |ctm|
      list_customer << content_tag(:p, ctm.name, class: "mb-2")
    end
    safe_join list_customer
  end

  def can_edit_delete_project project
    current_user.can_edit_delete_project? project
  end

  def can_edit_project_member? project
    current_user.can_add_member? project
  end

  def project_select
    if current_user.admin? || current_user.manager?
      return Project.pluck(:name, :id)
    end

    Project.created_by_user_or_psm(current_user).pluck(:name, :id)
  end
end
