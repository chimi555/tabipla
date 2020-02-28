require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { create(:tag) }

  context 'バリデーションのテスト' do
    it '有効なtag' do
      expect(tag).to be_valid
    end

    it 'タグが31文字以上の場合無効であること' do
      tag = build(:tag, tag_name: "a" * 31)
      tag.valid?
      expect(tag.errors[:tag_name]).to include('は30文字以内で入力してください')
    end
  end
end
