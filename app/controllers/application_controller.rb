class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.\  
  before_action :set_local
  protect_from_forgery with: :exception
  include SessionsHelper


  def set_local
  end

  def account_type(account)
    return nil unless account.present?
    return 'email' if account ~= Patterns.email
    return 'mobile' if account ~= Patterns.mobile
    return 'name'
  end
end
