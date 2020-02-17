class Trip < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :name, presence: true
  validates :content, length: { maximum: 140 }
  validate :picture_size

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    errors.add(:picture, 'shoule be less than 5MB') if picture.size > 5.megabytes
  end
end
