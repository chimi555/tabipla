class Tag < ApplicationRecord
  # モデルの関連定義
  has_many :trips, through: :trip_tags
  has_many :trip_tags, dependent: :destroy
  # バリデーション
  validates :tag_name, presence:true, length: { maximum: 30 }
end
