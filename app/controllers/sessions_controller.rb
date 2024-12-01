# frozen_string_literal: true

# Handles session page
class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :check_session, only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: lambda {
    redirect_to new_session_url, alert: t('auth.limit_signin')
  }

  layout 'authentication'

  def new; end

  def create
    if (user = User.authenticate_by(params.permit(:email_address, :password)))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: t('auth.failed_signin')
    end
  end

  def destroy
    terminate_session
    redirect_to root_path
  end

  private

  def check_session
    redirect_to root_path, notice: t('auth.already_authenticated') if authenticated?
  end
end
