# frozen_string_literal: true

# Handles registration page
class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :check_session

  layout 'authentication'

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: t('auth.success_signup')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end

  def check_session
    redirect_to root_path, notice: t('auth.already_authenticated') if authenticated?
  end
end
