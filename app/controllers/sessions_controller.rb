class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by_account(user_params[:account])
    if user && user.authenicate(user_params[:password])
      if account_type(user_params[:account]) == "email" 
        if user.activated?
          log_in(user)
          redirect_back_or user
        else
          flash[:message] = "please activate your account"
          redirect_to root_url
        end
      else
        log_in(user)
        params[:user][:remember_me] == "1" ? remember(user) : forget(user) 
      end
    else
    end
  end

  private
    def user_params
      params.require(:user).permit(:account,:name,:email,:phone,:password,:password_confirmation,:verify_code)
    end
end
