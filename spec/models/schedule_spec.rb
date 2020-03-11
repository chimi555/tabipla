require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:schedule) { create(:schedule) }

  context 'バリデーションのテスト' do
    example '有効なschedule' do
      expect(schedule).to be_valid
    end

    example '場所名が31文字以上は無効であること' do
      schedule = build(:schedule, place: "a" * 31)
      schedule.valid?
      expect(schedule.errors[:place]).to include('は30文字以内で入力してください')
    end

    example 'メモが141文字以上は無効であること' do
      schedule = build(:schedule, memo: "a" * 141)
      schedule.valid?
      expect(schedule.errors[:memo]).to include('は140文字以内で入力してください')
    end
  end

  context 'アソシエーションのテスト' do
    example 'dayが削除されると、scheduleも削除される' do
      expect { schedule }.to change(Schedule, :count).by(+1)
      schedule.day.destroy
      expect(Day.count).to eq 0
      expect(Schedule.count).to eq 0
    end
  end
end
