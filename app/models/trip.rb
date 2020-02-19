class Trip < ApplicationRecord
  # モデルの関連定義
  belongs_to :user
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules, allow_destroy: true
  # scope
  default_scope -> { order(created_at: :desc) }
  # バリデーション
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 140 }
  validate :picture_size
  # ファイルアップローダー
  mount_uploader :picture, PictureUploader

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    errors.add(:picture, 'shoule be less than 5MB') if picture.size > 5.megabytes
  end
end
