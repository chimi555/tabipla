require 'rails_helper'

RSpec.describe 'Follow', type: :system do
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

      example 'フォローボタンが表示されること' do
        expect(page).to have_button "フォローする"
      end

      example 'フォローでき、Unfollowボタンに変わること' do
        click_button "フォローする"
        expect(user.following.count).to eq 1
        expect(page).to have_button "フォロー済"
      end
    end

    context 'フォローしているユーザーのページ' do
      before do
        user.follow(other_user)
        visit user_path(other_user.id)
      end

      example 'アンフォローボタンが表示されること' do
        expect(page).to have_button "フォロー済"
      end

      example 'アンフォローでき、Followボタンに変わること' do
        click_button "フォロー済"
        expect(page).to have_button "フォローする"
      end
    end
  end
end
