class Schedule < ApplicationRecord
  #モデルの関連定義
  belongs_to :trip

  #バリデーション
  validates :trip_id, presence: true
end
