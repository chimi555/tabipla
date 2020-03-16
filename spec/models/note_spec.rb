require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:note) { create(:note) }

  context 'バリデーションのテスト' do
    example '有効なnote' do
      expect(note).to be_valid
    end

    example '旅行メモタイトルが31文字以上は無効であること' do
      note = build(:note, subject: "a" * 31)
      note.valid?
      expect(note.errors[:subject]).to include('は30文字以内で入力してください')
    end
  end

  context 'アソシエーションのテスト' do
    example 'tripが削除されると、noteも削除される' do
      expect { note }.to change(Note, :count).by(+1)
      note.trip.destroy
      expect(Trip.count).to eq 0
      expect(Note.count).to eq 0
    end
  end
end
