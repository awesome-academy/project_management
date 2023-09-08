class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  include FormHelper
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash_logged_in_user_danger"
    redirect_to login_url, status: :see_other
  end

  def verify_admin
    return if current_user&.admin?

    flash[:danger] = t "flash_verify_admin_danger"
    redirect_to request.referer || root_path
  end

  def verify_manager
    return if current_user&.manager?

    flash[:danger] = t "flash_verify_manager_danger"
    redirect_to request.referer || root_path
  end
end
