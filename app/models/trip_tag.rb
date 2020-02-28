class TripTag < ApplicationRecord
  # モデルの関連定義
  belongs_to :trip
  belongs_to :tag
  # バリデーション
  validates :trip_id, presence:true
  validates :tag_id, presence:true
end
