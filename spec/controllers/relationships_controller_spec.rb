require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe '#create' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
      end

      it 'ユーザーをフォローできること' do
        expect do
          post :create, params: { followed_id: other_user.id }
        end.to change(user.following, :count).by(1)
      end

      it 'Ajaxによるフォローができること' do
        expect do
          post :create, params: { followed_id: other_user.id }, xhr: true
        end.to change(user.following, :count).by(1)
      end
    end

    context 'ログインしていないユーザー' do
      it 'ユーザーをフォローできず、ログインページへリダイレクトすること' do
        expect do
          post :create, params: { followed_id: other_user.id }
        end.not_to change(Relationship, :count)
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'ログイン済ユーザー' do
      before do
        sign_in user
      end

      it 'ユーザーをアンフォローできること' do
        user.follow(other_user)
        relationship = user.active_relationships.find_by(followed_id: other_user.id)
        expect do
          delete :destroy, params: { id: relationship.id }
        end.to change(user.following, :count).by(-1)
      end

      it 'Ajaxによるアンフォローができること' do
        user.follow(other_user)
        relationship = user.active_relationships.find_by(followed_id: other_user.id)
        expect do
          delete :destroy, params: { id: relationship.id }, xhr: true
        end.to change(user.following, :count).by(-1)
      end
    end

    context 'ログインしていないユーザー' do
      it 'ユーザーをアンフォローできず、ログインページへリダイレクトすること' do
        user.follow(other_user)
        relationship = user.active_relationships.find_by(followed_id: other_user.id)
        expect do
          delete :destroy, params: { id: relationship.id }
        end.not_to change(Relationship, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
