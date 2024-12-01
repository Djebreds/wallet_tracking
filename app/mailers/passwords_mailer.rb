# frozen_string_literal: true

# Handles password mailer
class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: t('auth.reset_password'), to: user.email_address
  end
end
