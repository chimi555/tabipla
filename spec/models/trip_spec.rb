require 'rails_helper'

RSpec.describe Trip, type: :model do
  context "バリデーションのテスト" do
    it '有効な状態' do
      expect(create(:trip)).to be_valid
    end

    it "名前がなければ無効である" do
      trip =  build(:trip, name: nil)
      expect(trip.valid?).to eq(false)
    end
  end
end
