class User < ActiveRecord::Base
  # validates :email,pr
  attr_accessor :account,:password,:verify_code,:email_activation_token,:remember_token
  # befor_save 
  validates_uniqueness_of :mobile
  validates :account, presence: true
  validates :email, format: {with: Patterns.email}
  validates :mobile, format: {with: Patterns.mobile}
  validates :password, presence: true,length: {minimum: 6}

  validate :check_very_code


#  after_sig_in sign_in_count++

  def check_very_code
    if 
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
