require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:note) { create(:note) }

  context 'バリデーションのテスト' do
    it '有効なnote' do
      expect(note).to be_valid
    end

    it "tripIDがなければ無効な状態であること" do
      note = build(:note, trip_id: nil)
      note.valid?
      expect(note.errors[:trip_id]).to include("を入力してください")
    end

    it '旅行メモタイトルが31文字以上は無効であること' do
      note = build(:note, subject: "a" * 31)
      note.valid?
      expect(note.errors[:subject]).to include('は30文字以内で入力してください')
    end

    it '旅行メモ内容が141文字以上は無効であること' do
      note = build(:note, content: "a" * 141)
      note.valid?
      expect(note.errors[:content]).to include('は140文字以内で入力してください')
    end
  end
end
