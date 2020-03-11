require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:trip) { create(:trip) }
  let(:like) { create(:like, user: user, trip: trip) }

  describe '#create' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
      end

      example 'お気に入り登録できること' do
        expect do
          post :create, params: { trip_id: trip.id }
        end.to change(user.likes, :count).by(1)
      end

      example 'Ajaxによるお気に入り登録ができること' do
        expect do
          post :create, params: { trip_id: trip.id }, xhr: true
        end.to change(user.likes, :count).by(1)
      end
    end

    context 'ログインしていないユーザー' do
      example 'お気に入り登録できないこと' do
        expect do
          post :create, params: { trip_id: trip.id }
        end.not_to change(user.likes, :count)
      end
    end
  end

  describe '#destroy' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
      end

      example 'お気に入り解除できること' do
        like
        expect do
          delete :destroy, params: { id: like.id }
        end.to change(user.likes, :count).by(-1)
      end

      example 'Ajaxによるお気に入り解除ができること' do
        like
        expect do
          delete :destroy, params: { id: like.id }, xhr: true
        end.to change(user.likes, :count).by(-1)
      end
    end

    context 'ログインしていないユーザー' do
      example 'お気に入り解除できないこと' do
        like
        expect do
          delete :destroy, params: { id: like.id }
        end.not_to change(user.likes, :count)
      end
    end
  end
end
