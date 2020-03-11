require 'rails_helper'

RSpec.describe TripTag, type: :model do
  let(:trip_tag) { create(:trip_tag) }

  context 'バリデーションのテスト' do
    example "有効なtrip_tagレコードが登録できること" do
      expect(trip_tag).to be_valid
    end

    example "tripIDがなければ無効な状態であること" do
      trip_tag = build(:trip_tag, trip_id: nil)
      expect(trip_tag).not_to be_valid
    end

    example "tagIDがなければ無効な状態であること" do
      trip_tag = build(:trip_tag, tag_id: nil)
      expect(trip_tag).not_to be_valid
    end
  end
end
