require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { create(:relationship) }

  context 'バリデーションのテスト' do
    example "有効なrelationshipレコードが登録できること" do
      expect(relationship).to be_valid
    end

    example "フォロワーIDがなければ無効な状態であること" do
      relationship = build(:relationship, follower_id: nil)
      expect(relationship).not_to be_valid
    end

    example "tripIDがなければ無効な状態であること" do
      relationship = build(:relationship, followed_id: nil)
      expect(relationship).not_to be_valid
    end
  end
end
