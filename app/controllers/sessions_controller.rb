class SessionsController < ApplicationController
  def new
    redirect_to(root_url) if current_user
    @user = User.new
  end

  def create

    @user = User.find_by_account(user_params[:account])
     valid_rucaptcha =  verify_rucaptcha?
    if @user && valid_rucaptcha && @user.authenticate(user_params[:password])

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
      if !@user.authenticate(user_params[:password])
        @user.errors.add(:password, "密码错误")
      end
      if !valid_rucaptcha
        @user.errors.add(:base,"验证码错误")
        # flash.now[:danger] = "验证码错误" 
      end
      render "new"
    end
  end

  def destroy
    log_out
    flash[:message] = "退出成功"
    redirect_to root_url
  end

  private
    def user_params
      params.require(:user).permit(:account,:_rucaptcha,:name,:email,:phone,:password,:password_confirmation,:verify_code)
    end

end
