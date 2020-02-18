class Schedule < ApplicationRecord
  #モデルの関連定義
  belongs_to :trip

  #バリデーション
  validates :trip_id, presence: true
  validates :date, presence:true
  validates :place, presence:true
  validates :memo, length: { maximum: 140 }
end
