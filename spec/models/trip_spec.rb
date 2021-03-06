require 'rails_helper'

RSpec.describe Trip, type: :model do
  let(:trip) { create(:trip) }

  context 'バリデーションのテスト' do
    example '有効なユーザー' do
      expect(trip).to be_valid
    end

    example "ユーザーIDがなければ無効な状態であること" do
      trip = build(:trip, user_id: nil)
      trip.valid?
      expect(trip.errors[:user_id]).to include("を入力してください")
    end

    example '旅行名がなければ無効であること' do
      trip = build(:trip, name: nil)
      trip.valid?
      expect(trip.errors[:name]).to include('を入力してください')
    end

    example '旅行名が30文字以上は無効であること' do
      trip = build(:trip, name: "a" * 31)
      trip.valid?
      expect(trip.errors[:name]).to include('は30文字以内で入力してください')
    end

    example '旅行概要が140文字以上は無効であること' do
      trip = build(:trip, content: "a" * 141)
      trip.valid?
      expect(trip.errors[:content]).to include('は140文字以内で入力してください')
    end

    example 'エリア名が30文字以上は無効であること' do
      trip = build(:trip, area: "a" * 31)
      trip.valid?
      expect(trip.errors[:area]).to include('は30文字以内で入力してください')
    end
  end
end
