class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @greeting = 'Click the link below to activate your account!'
    @user = user
    mail to: @user.email, subject: 'Account activation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_resets.subject
  #
  def password_reset(user)
    @greeting = 'Click the link below to reset your password'
    @user = user
    mail to: @user.email, subject: 'Password reset'
  end
end