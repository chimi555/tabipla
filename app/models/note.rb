class Note < ApplicationRecord
  # モデルの関連定義
  belongs_to :trip
  # scope
  default_scope -> { order(id: :asc) }
  # バリデーション
  validates :subject, length: { maximum: 30 }
  validates :trip_id, presence: true
end
