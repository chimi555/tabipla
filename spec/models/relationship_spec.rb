require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { create(:relationship) }

  context 'バリデーションのテスト' do
    it "有効なrelationshipレコードが登録できること" do
      expect(relationship).to be_valid
    end

    it "フォロワーIDがなければ無効な状態であること" do
      relationship = build(:relationship, follower_id: nil)
      expect(relationship).not_to be_valid
    end

    it "tripIDがなければ無効な状態であること" do
      relationship = build(:relationship, followed_id: nil)
      expect(relationship).not_to be_valid
    end
  end
end
