require 'rails_helper'

describe AccountActivationsController, type: :controller do
  let(:user) { create :unactivated_user }
  let(:creator) { user.creator }
  let(:user_attrs) { attributes_for :user }

  context 'attempt activate account' do
    it 'with valid params will retain existing creator association and update updater association (w/itself)' do
      session[:user_id] = user.id
      patch :update, id: user, email: user.email, user: { password: user_attrs[:password], password_confirmation: user_attrs[:password] }
      user.reload
      expect(user.creator).to eq creator
      expect(user.updater).to eq user
      expect(creator.created_users).to include user
      expect(creator.updated_users).not_to include user
      expect(user.created_users).not_to include user
      expect(user.updated_users).to include user
    end

    it 'with invalid params will retain existing creator association and update updater associations' do
      session[:user_id] = user.id
      patch :update, id: user, email: user.email, user: { password: '', password_confirmation: '' }
      user.reload
      expect(user.creator).to eq creator
      expect(user.updater).to eq creator
      expect(creator.created_users).to include user
      expect(creator.updated_users).to include user
      expect(user.created_users).not_to include user
      expect(user.updated_users).not_to include user
    end
  end
end
