class User < ApplicationRecord
  # モデルの関連定義
  has_many :trips, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_trips, through: :likes, source: :trip
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]
  # 追加のattribute
  attr_accessor :login
  attr_accessor :current_password
  # バリデーション
  validates :user_name, presence: true, length: { maximum: 20 }
  validates :email, uniqueness: true, presence: true
  # ファイルアップローダー
  mount_uploader :image, ImageUploader
  # roleのenum定義
  enum role: { normal: 0, admin: 1, guest: 2 }

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

  # お気に入り
  def like(trip)
    likes.create(trip_id: trip.id)
  end

  # お気に入りを解除する
  def unlike(trip)
    likes.find_by(trip_id: trip.id).destroy
  end

  # すでにお気に入りしていたらtrueを返す
  def already_liked?(trip)
    liked_trips.include?(trip)
  end

  # 自分のtrip以外のliked_trips
  def liked_trips_list
    liked_trips.where.not(user_id: id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
end
