require 'rails_helper'

describe AccountActivationsController, type: :controller do
  let(:user) { create :user_with_creator }
  let(:user_creator) { user.creator }
  let(:user_attrs) { attributes_for :user }

  context 'attempt activate account' do
    it 'with valid params will retain existing creator association and update updater association (w/itself)' do
      session[:user_id] = user.id
      patch :update, id: user, email: user.email, user: { password: user_attrs[:password], password_confirmation: user_attrs[:password] }
      user.reload
      expect(user.creator).to eq user_creator
      expect(user.updater).to eq user
      expect(user_creator.created_users).to include user
      expect(user_creator.updated_users).not_to include user
      expect(user.created_users).not_to include user
      expect(user.updated_users).to include user
    end

    it 'with invalid params will retain existing creator and updater associations' do
      session[:user_id] = user.id
      patch :update, id: user, email: user.email, user: { password: '', password_confirmation: '' }
      user.reload
      expect(user.creator).to eq user_creator
      expect(user.updater).to eq user_creator
      expect(user_creator.created_users).to include user
      expect(user_creator.updated_users).to include user
      expect(user.created_users).not_to include user
      expect(user.updated_users).not_to include user
    end

    it 'as user other than account owner' do
      session[:user_id] = user_creator.id
      patch :update, id: user, email: user.email, user: { password: user_attrs[:password], password_confirmation: user_attrs[:password] }
      user.reload
      expect(user.creator).to eq user_creator
      expect(user.updater).to eq user_creator
      expect(user_creator.created_users).to include user
      expect(user_creator.updated_users).to include user
      expect(user.created_users).not_to include user
      expect(user.updated_users).not_to include user
    end
  end
end
