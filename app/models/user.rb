class User < ActiveRecord::Base
  # validates :email,pr
  attr_accessor :account,:verify_code,:email_activation_token,:remember_token
  # befor_save 
  validates_uniqueness_of :mobile
  validates :account, presence: true
  validates :email, format: {with: Patterns.email},presence: true,:if => lambda{|u| u.email.present?}
  validates :mobile, format: {with: Patterns.mobile},presence: true,if: lambda{|u| u.mobile.present?}

  validates :password, presence: true,length: {minimum: 6}

  validate :check_very_code
 
  validates_uniqueness_of :name


  has_secure_password

  before_create :create_activation_digest
#  after_sig_in sign_in_count++


  def create_activation_digest
    self.email_activation_token =  User.new_token
    self.email_activation_digest = User.digest(email_activation_token)
  end

  def check_very_code

  end


  


  def send_active_email

  end

  def set_new_remember_digest
    self.remember_token = User.new_token
    update_attribute(remember_digest: User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = self.send "#{attribute}_digest"
    return false if digest.nil?
    Bcrypt::Password.new(digest).is_password?(token)
  end

  def clear_remember_digest
      update_attribute(remember_digest: nil)
  end

  def activated_by_email?
    email_verified
  end


  def activate(activation_mode)
    default_activations = [:email, :mobile]

    if default_activations.include?(activation_mode)
      method_name = "#{activation_mode}_verified"
      send(update_attribute,method_name,true) if respond_to?(method_name)
      # update_attribute(:email_verified, true)
      update_attribute(:activated_at, Time.now)
    else
      return nil
    end
  end



  class  << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? Bcrypt::Engine::MIN_COST
       : Bcrypt::Engine.cost
       Bcrypt::Password.create(string,cost: cost) 
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def find_by_account(val)
      account = account_type(val)
      send("find_by_#{account}") 
    end

  end


end
