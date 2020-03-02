require 'rails_helper'

RSpec.describe 'Trips', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "フォロー・アンフォロー機能" do
    before do
      sign_in user
    end

    context 'まだフォローしていないユーザーのページ' do
      before do
        visit user_path(other_user.id)
      end

      it 'フォローボタンが表示されること' do
        expect(page).to have_button "Follow"
      end

      it 'フォローでき、Unfollowボタンに変わること' do
        click_button "Follow"
        expect(user.following.count).to eq 1
        expect(page).to have_button "Unfollow"
      end
    end

    context 'フォローしているユーザーのページ' do
      before do
        user.follow(other_user)
        visit user_path(other_user.id)
      end

      it 'アンフォローボタンが表示されること' do
        expect(page).to have_button "Unfollow"
      end

      it 'アンフォローでき、Followボタンに変わること' do
        click_button "Unfollow"
        expect(page).to have_button "Follow"
      end
    end
  end
end
