require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:trip) { create(:trip) }

  describe '#create' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
      end

     # it 'お気に入り登録できる' do
     #  like_params = attributes_for(:like, {
     #    trip_id: trip.id,
     #  })
     #  expect do
     #    post :create, params: { like: like_params }
     #  end.to change(user.likes, :count).by(1)
     #end
    end

    context 'ログインしていないユーザー' do
      it 'お気に入り登録できない' do
        like_params = attributes_for(:like, {
          trip_id: trip.id,
        })
        expect do
          post :create, params: { like: like_params }
        end.not_to change(user.likes, :count)
      end
    end
  end

end
