class Schedule < ApplicationRecord
  # モデルの関連定義
  belongs_to :day
  # scope
  default_scope -> { order(id: :asc) }
  # バリデーション
  validates :place, length: { maximum: 30 }
end
