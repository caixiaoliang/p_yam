class UsersController < ApplicationController
  
  #
  def new
    @user = User.new
  end

# 注册
  def create
    @user = User.new(params[:user])

    if @user.save
      if account_type == 'email'
        UserMailer.account_activation(@user).deliver_now
        flash[:info] = "please check your email to activate your account"
        redirect_to root_url
      end
      redirect_back_or @user
    else
      render "new"
    end
  end

  def edit
  end


  def account_activation
    user = User.find_by_email(params[:email])
    if user && !user.activated? && user.authenticated?(:email_activation, params[:id])
      user.update_attributes(email_verified: true, activated_at: Time.now)
      log_in(user)
      flash[:message] = "account activated"
      redirect_back_or user
    else
      flash[:message] = "invalid activation link"
      redirect_to root_url
    end
  end

  def show

  end



end
