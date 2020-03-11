require 'rails_helper'

RSpec.describe Day, type: :model do
  let(:day) { create(:day) }

  context 'バリデーションのテスト' do
    example "有効なdayレコードが登録できること" do
      expect(day).to be_valid
    end
  end

  context 'アソシエーションのテスト' do
    example 'tripが削除されると、dayも削除される' do
      expect { day }.to change(Day, :count).by(+1)
      day.trip.destroy
      expect(Trip.count).to eq 0
      expect(Day.count).to eq 0
    end
  end
end
