require 'rails_helper'

RSpec.describe Day, type: :model do
  let(:day) { create(:day) }

  context 'バリデーションのテスト' do
    it "有効なdayレコードが登録できること" do
      expect(day).to be_valid
    end
  end
end
