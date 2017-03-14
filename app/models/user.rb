class User < ActiveRecord::Base
  # validates :email,pr
  attr_accessor :account,:verify_code,:email_activation_token,:remember_token,
        :system_verify_data
  # befor_save 
  validates_uniqueness_of :mobile,if: lambda{|u| u.mobile.present?}
  validates :account, presence: true
  validates :email, format: {with: Patterns.email},presence: true,:if => lambda{|u| u.email.present?}
  validates :mobile, format: {with: Patterns.mobile},presence: true,if: lambda{|u| u.mobile.present?}
  validates :password, presence: true,length: {minimum: 6}
  validate :check_verify_code, if: lambda{|u| u.mobile.present?},on: :create
  validates :name,presence: true
  validates_uniqueness_of :name
  validates_uniqueness_of :email, if: lambda{|u| u.email.present?}
  validates_uniqueness_of :mobile, if: lambda{|u| u.mobile.present?}
  validates_confirmation_of :password
  has_secure_password

  # before_create :create_activation_digest
  # after_sig_in sign_in_count++


  def create_activation_digest
    self.email_activation_token =  User.new_token
    self.email_activation_digest = User.digest(email_activation_token)
  end
  
  #不为空 
  def check_verify_code
    binding.pry
    effective_time = 10.minute
    hash = self.system_verify_data.symbolize_keys!
    # {account: mobile,verify_code: code, sent_at: Time.now}
    slef.errors.add(:verify_code,"验证码不能为空") unless hash[:verify_code].present?
    slef.errors.add(:verify_code,"验证码错误或过期") if (hash[:sent_at].to_time + effective_time) < Time.now && self.verify_code != hash[:verify_code]
  end

  def set_new_remember_digest
    self.remember_token = User.new_token
    update_attribute(remember_digest: User.digest(remember_token))
  end

  # 
  def authenticated?(attribute, token)
    digest = self.send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def clear_remember_digest
      update_attribute(:remember_digest, nil)
  end

  def activated_by_email?
    email_verified
  end


  def activate(activation_mode)
    default_activations = [:email, :mobile]

    if default_activations.include?(activation_mode)
      field_name = "#{activation_mode}_verified"
      send(:update_attribute, field_name,true) if respond_to?(field_name)
      # update_attribute(:email_verified, true)
      update_attribute(:activated_at, Time.now)
    else
      return nil
    end
  end



  class  << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
       : BCrypt::Engine.cost
       BCrypt::Password.create(string,cost: cost) 
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def account_type(account)
      return nil unless account.present?
      return 'email' if account =~ Patterns.email
      return 'mobile' if account =~ Patterns.mobile
      return 'name'
    end

    def find_by_account(val)
      account = account_type(val)
      send("find_by_#{account}",val) 
    end

  end


end
