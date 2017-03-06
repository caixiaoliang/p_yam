class UserMailer < ActionMailer::Base
  default from: "xx@xx.com"

  def account_activation(user)
    @user = user
    mail to: user.email,subject: "Account  activation"
  end
end