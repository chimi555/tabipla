class Like < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  # バリデーション
  validates :trip_id, presence: true
  validates :user_id, presence: true
end
