class UsersController < ApplicationController
    protect_from_forgery :except => :new

  #
  def new
    redirect_back_or(current_user) if current_user
    @user = User.new
  end

# 注册
  def create
    binding.pry
    @user = User.new(user_params)
    account = account_type(user_params[:account])
    valid_rucaptcha =  verify_rucaptcha?(@user)
    if account == 'mobile'
      mobile = user_params[:account].to_s
      @user.mobile_verified = true
      @user.mobile = mobile
      @user.system_verify_data = get_verify_data 
    elsif account == 'email'
      @user.email = user_params[:account].to_s
      @user.create_activation_digest
    end

    if valid_rucaptcha && @user.save
      if account  == 'email'
        send_active_email(@user)
        flash[:info] = " 请登录到邮箱激活帐户"
        redirect_to root_url
      else
        log_in(@user)
        Sms.clear_limit(mobile)
        flash[:message] = "注册成功"
        redirect_to @user
      end
    else
      flash.now[:message]= "验证码错误"  if !valid_rucaptcha
      render "new"
    end
  end

  def edit
  end


  def account_activation
    user = User.find_by_email(params[:email])
    binding.pry
    if user && !user.activated_by_email? && user.authenticated?(:email_activation, params[:id])

      user.activate(:email)
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

  def send_verify_code
    #   验证码有效时间
    mobile = params[:account]
    if mobile =~ Patterns.mobile
      return render json: {code: 404,msg: "fail"} if User.find_by_mobile(params[:account])
      return render json: {code: 403,msg: "forbidden"} if Sms.is_limited?(mobile)
      code = Sms.random_code
      Sms.send_verify_code(mobile,code)
      session[:sms_reg] = {account: mobile,verify_code: code, sent_at: Time.now}
      render json: {code: 200,msg: "sent"}
    else
      render json: {code: 404,msg: "fail"}
    end
  end


  private
    def user_params
      params.require(:user).permit(:account,:_rucaptcha,:name,:email,:phone,:password,:password_confirmation,:verify_code)
    end

    def get_verify_data
      session[:sms_reg] || {}
    end

    def clear_verify_data
      session.delete(:sms_reg)
    end

end
