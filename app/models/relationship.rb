class Relationship < ApplicationRecord
  # モデルの関連定義
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # バリデーション
  validates :trip_id, presence: true
  validates :tag_id, presence: true
end
end
