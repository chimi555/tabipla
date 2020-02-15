class User < ApplicationRecord
  attr_accessor :login
  attr_accessor :current_password
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         authentication_keys: [:login]

  has_many :trips, dependent: :destroy
  validates :user_name, presence: true, length: { maximum: 20 }
  validates :email, uniqueness: true, presence: true 

  def login
    @login || user_name || email
  end

  # ログイン認証の条件をオーバーライド
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).
        where(['lower(user_name) = :value OR lower(email) = :value', { value: login.downcase }]).
        first
    elsif conditions.key?(:user_name) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

  # facebookログイン
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.user_name = auth.info.name # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
