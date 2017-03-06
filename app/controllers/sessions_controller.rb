class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by_account(params[:user][:account])
    if user && user.authenicate(params[:user][:password])
      if account_type(params[:user][:account])=="email" 
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
end
