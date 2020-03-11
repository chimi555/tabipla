require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context 'バリデーションのテスト' do
    example '有効なユーザー' do
      expect(user).to be_valid
    end

    example 'ユーザーネームがなければ無効であること' do
      user = build(:user, user_name: nil)
      user.valid?
      expect(user.errors[:user_name]).to include('が入力されていません。')
    end

    example 'ユーザーネームが20文字以上は無効であること' do
      user = build(:user, user_name: "a" * 21)
      user.valid?
      expect(user.errors[:user_name]).to include('は20文字以下に設定して下さい。')
    end

    example 'メールアドレスがなければ無効であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('が入力されていません。')
    end

    example 'メールアドレスが重複していれば無効であること' do
      other_user = build(:user, email: user.email)
      other_user.valid?
      expect(other_user.errors[:email]).to include('は既に使用されています。')
    end

    example "パスワードがなければ無効であること" do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to include("が入力されていません。")
    end

    example "パスワードが5文字以下だと無効であること" do
      user = build(:user, password: "a" * 5, password_confirmation: "a" * 5)
      user.valid?
      expect(user.errors.messages[:password]).to include('は6文字以上に設定して下さい。')
    end
  end
end
