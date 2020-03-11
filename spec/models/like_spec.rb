require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) { create(:like) }

  context 'バリデーションのテスト' do
    example "有効なlikeレコードが登録できること" do
      expect(like).to be_valid
    end

    example "ユーザーIDがなければ無効な状態であること" do
      like = build(:like, user_id: nil)
      expect(like).not_to be_valid
    end

    example "tripIDがなければ無効な状態であること" do
      like = build(:like, trip_id: nil)
      expect(like).not_to be_valid
    end
  end
end
