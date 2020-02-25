require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:note) { create(:note) }

  context 'バリデーションのテスト' do
    it '有効なnote' do
      expect(note).to be_valid
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

  context 'アソシエーションのテスト' do
    it 'tripが削除されると、noteも削除される' do
      expect { note }.to change(Note, :count).by(+1)
      note.trip.destroy
      expect(Trip.count).to eq 0
      expect(Note.count).to eq 0
    end
  end
end
