class User < ApplicationRecord
  has_many :role_users, dependent: :destroy
  has_many :roles, through: :role_users
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :reports, dependent: :destroy
  has_many :created_projects, class_name: Project.name,
           foreign_key: :creator_id, dependent: nil

  attr_accessor :remember_token, :reset_token

  VALID_EMAIL_REGEX = Settings.email.regex

  validates :email, presence: true,
            length: {maximum: Settings.digits.length_255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  validates :password, presence: true,
            length: {minimum: Settings.digits.length_6},
            allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
    remember_digest
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = begin
      send "#{attribute}_digest"
    rescue NoMethodError
      nil
    end
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def admin?
    roles.find_by(name: Settings.user_roles.admin).present?
  end

  def manager?
    roles.find_by(name: Settings.user_roles.manager).present?
  end

  def creator_project? project
    created_projects.exists?(id: project.id)
  end

  def role_psm? project
    role = Role.find_by(name: Settings.project_roles.PSM)
    ProjectUser.find_by(project_role_id: role.id,
                        project_id: project.id,
                        user_id: id)
  end

  def projects_role_psm
    role = Role.find_by(name: Settings.project_roles.PSM)

    if role
      projects = Project.joins(:project_users).where(project_users: {
                                                       user_id: id,
                                                       project_role_id: role.id
                                                     })
    else
      projects = []
    end

    projects
  end

  def can_edit_delete_project? project
    admin? || manager? || creator_project?(project) || role_psm?(project)
  end

  def user_role_project
    project_id_have_role_plm =
      project_users.id_have_user_roles Settings.project_roles.PSM
    Project.where id: created_project_ids.concat(project_id_have_role_plm).uniq
  end

  def valid_projects_by_role
    if admin? || manager?
      Project.all
    else
      user_role_project
    end
  end
end
