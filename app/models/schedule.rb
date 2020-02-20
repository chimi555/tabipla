class Schedule < ApplicationRecord
  # モデルの関連定義
  belongs_to :trip
  # バリデーション
  validates :place, length: { maximum: 30 }
  validates :memo, length: { maximum: 140 }
end
