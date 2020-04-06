class Day < ApplicationRecord
  # モデルの関連定義
  belongs_to :trip
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules, allow_destroy: true
  # scope
  default_scope -> { order(id: :asc) }
  # バリデーション
  validates :trip_id, presence: true
  validates :date, presence: true
end
