class Trip < ApplicationRecord
  # モデルの関連定義
  belongs_to :user
  has_many :notes, dependent: :destroy
  accepts_nested_attributes_for :notes, allow_destroy: true
  has_many :days, dependent: :destroy
  accepts_nested_attributes_for :days, allow_destroy: true
  has_many :likes, dependent: :destroy
  has_many :trip_tags, dependent: :destroy
  has_many :tags, through: :trip_tags
  # scope
  default_scope -> { order(created_at: :desc) }
  # バリデーション
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 140 }
  validates :area, length: { maximum: 30 }
  validate :picture_size
  # ファイルアップローダー
  mount_uploader :picture, PictureUploader

  # 国名を翻訳
  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  # タグ更新処理
  def save_tags(tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    # 古いタグを削除
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name: old_name)
    end

    # 新しいタグを追加
    new_tags.each do |new_name|
      trip_tag = Tag.find_or_create_by(tag_name: new_name)
      self.tags << trip_tag
    end
  end

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    errors.add(:picture, 'shoule be less than 5MB') if picture.size > 5.megabytes
  end
end
