class Note < ApplicationRecord
  # モデルの関連定義
  belongs_to :trip
  # バリデーション
  validates :subject, length: { maximum: 30 }
  validates :content, length: { maximum: 140 }
end
