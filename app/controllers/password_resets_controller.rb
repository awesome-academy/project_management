class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".flash_info_create"
      redirect_to login_url
    else
      flash.now[:danger] = t ".flash_danger_create"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if params.dig(:user, :password).empty?
      @user.errors.add :password, t(".empty_password_error")
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      reset_session
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t ".flash_update_success"
      redirect_to root_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t ".flash_get_user_danger"
    redirect_to root_url
  end

  # Confirms a valid user.
  def valid_user
    return if @user.authenticated?(:reset, params[:id])

    flash[:danger] = t ".flash_valid_user_danger"
    redirect_to root_url
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".flash_check_expiration_danger"
    redirect_to new_password_reset_url
  end
end
