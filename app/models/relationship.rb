class Relationship < ApplicationRecord
  # モデルの関連定義
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # バリデーション
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
