class SessionsController < ApplicationController
  def new
    redirect_back_or(current_user) if current_user
    @user = User.new
  end

  def create
    @user = User.find_by_account(user_params[:account])
    if @user && @user.authenticate(user_params[:password])
      if account_type(user_params[:account]) == "email" 
        if @user.activated_by_email?
          log_in(@user)
          redirect_to root_url
        else
          flash[:message] = "请激活你的帐户"
          redirect_to root_url
        end
      else
        log_in(@user)
        params[:user][:remember_me] == "1" ? remember(@user) : forget(@user) 
        redirect_to root_url
      end
    else
      flash.now[:message] = "密码错误"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit(:account,:name,:email,:phone,:password,:password_confirmation,:verify_code)
    end
end
