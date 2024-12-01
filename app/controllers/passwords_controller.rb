# frozen_string_literal: true

# Handles password page
class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :check_session
  before_action :set_user_by_token, only: %i[edit update]

  layout 'authentication'

  def new; end

  def edit; end

  def create
    if (user = User.find_by(email_address: params[:email_address]))
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: t('auth.password_reset_instruction')
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: t('auth.success_password_reset')
    else
      redirect_to edit_password_path(params[:token]), alert: t('auth.failed_password_reset')
    end
  end

  private

  def set_user_by_token
    @user = User.find_by!(password_reset_token: params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path, alert: t('auth.expired_password_reset')
  end

  def check_session
    redirect_to root_path, notice: t('auth.already_authenticated') if authenticated?
  end
end
