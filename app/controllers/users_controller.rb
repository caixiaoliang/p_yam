class UsersController < ApplicationController
    protect_from_forgery :except => :new

  #
  def new
    redirect_back_or(current_user) if current_user
    @user = User.new
  end

# 注册
  def create
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
        @user.send_active_email
        flash[:info] = " 请登录到邮箱激活帐户"
        redirect_to root_url
      else
        log_in(@user)
        Sms.clear_limit(mobile)
        clear_verify_data
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
    user = User.find_by_account(params[:account])

    if user && !user.is_verified_with?(:email) && user.authenticated?(:email_activation, params[:id])

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
    @user = User.find(params[:id])
  end

  def destroy
    
  end

  # 找回密码时传入的env为reset_password
  # 注册邮箱时传入的env为reg
  def send_verify_code
    mobile = params[:account]
    key = "sms_#{params[:env]}".to_sym
    if mobile =~ Patterns.mobile
      # 如果是找回密码时则判断该手机用户存在否
      return render json: {code: 404,msg: "fail"} if key == :sms_reset_password && !User.find_by_mobile(params[:account])
      return render json: {code: 403,msg: "forbidden"} if Sms.is_limited?(mobile)
      code = Sms.random_code
      Sms.send_verify_code(mobile,code)
      session[key] = {account: mobile,verify_code: code, sent_at: Time.now}
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
