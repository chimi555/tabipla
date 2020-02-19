require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:schedule) { create(:schedule) }

  context 'バリデーションのテスト' do
    it '有効なschedule' do
      expect(schedule).to be_valid
    end

    it "tripIDがなければ無効な状態であること" do
      schedule = build(:schedule, trip_id: nil)
      schedule.valid?
      expect(schedule.errors[:trip_id]).to include("を入力してください")
    end

    it '場所名がなければ無効であること' do
      schedule = build(:schedule, place: nil)
      schedule.valid?
      expect(schedule.errors[:place]).to include('を入力してください')
    end

    it '場所名が31文字以上は無効であること' do
      schedule = build(:schedule, place: "a" * 31)
      schedule.valid?
      expect(schedule.errors[:place]).to include('は30文字以内で入力してください')
    end

    it 'メモが141文字以上は無効であること' do
      schedule = build(:schedule, memo: "a" * 141)
      schedule.valid?
      expect(schedule.errors[:memo]).to include('は140文字以内で入力してください')
    end
  end
end
