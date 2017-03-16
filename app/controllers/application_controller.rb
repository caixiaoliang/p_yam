class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.\  
  before_action :set_local
  # protect_from_forgery with: :exception
  protect_from_forgery
  include SessionsHelper


  def set_local
  end

  def account_type(account)
    return nil unless account.present?
    return 'email' if account =~ Patterns.email
    return 'mobile' if account =~ Patterns.mobile
    return 'name'
  end


  def verify_gt_captcha?(resource=nil)
    service = GeeTest.new('2fe323104e562daa06eda791634702ed')
    if service.validate(params[:geetest_challenge], params[:geetest_validate], params[:geetest_seccode])
      return true
    else
      resource.errors.add(:base, "验证码错误") if resource
      return false
    end
  end
end
