class UserMailer < ActionMailer::Base
  default from: "no-reply@p_yam.com"

  def account_activation(user)
    @user = user
    mail to: user.email,subject: "Account  activation"
  end
end