require 'rails_helper'

describe UsersController, type: :controller do
  let(:super_admin_user) { create :super_admin_user }
  let(:second_super_admin_user) { create :second_super_admin_user }
  let(:admin_user) { create :admin_user }
  let(:second_admin_user) { create :second_admin_user }
  let(:user) { create :user }
  let(:user_with_creator) { create :user_with_creator }
  let(:user_creator) { user_with_creator.creator }
  let(:second_user) { create :user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:second_suspended_super_admin_user) { create :second_suspended_super_admin_user }
  let(:second_suspended_admin_user) { create :second_suspended_admin_user }
  let(:second_suspended_user) { create :second_suspended_user }
  let(:user_attrs) { attributes_for :user }

  let(:user_params) {
    {
      name:   user_attrs[:name],
      email:  user_attrs[:email]
    }
  }

  let(:whitespace_user_params) { add_whitespace_to_values(user_params) }

  context 'attempt update as super-admin user' do
    it 'update unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', name: user_attrs[:name], response: super_admin_user },
        { user: second_super_admin_user, type: 'second_super_admin_user', name: second_super_admin_user.name, response: root_path },
        { user: admin_user, type: 'admin_user', name: admin_user.name, response: root_path },
        { user: user, type: 'user', name: user.name, response: root_path }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:name]).to eq u[:user].reload.name
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end

    it 'update suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt update as suspended super-admin user' do
    it 'update unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: second_suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt update as admin user' do
    it 'update unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', name: super_admin_user.name, response: root_path },
        { user: admin_user, type: 'admin_user', name: user_attrs[:name], response: admin_user },
        { user: second_admin_user, type: 'second_admin_user', name: second_admin_user.name, response: root_path },
        { user: user, type: 'user', name: user.name, response: root_path }
      ].each do |u|
        session[:user_id] = admin_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:name]).to eq u[:user].reload.name
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end

    it 'update suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = admin_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt update as suspended admin user' do
    it 'update unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: second_suspended_admin_user, type: 'second_suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt update as non-admin user' do
    it 'update unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', name: super_admin_user.name, response: root_path },
        { user: admin_user, type: 'admin_user', name: admin_user.name, response: root_path },
        { user: user, type: 'user', name: user_attrs[:name], response: user },
        { user: second_user, type: 'second_user', name: second_user.name, response: root_path }
      ].each do |u|
        session[:user_id] = user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:name]).to eq u[:user].reload.name
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end

    it 'update suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt update as suspended non-admin user' do
    it 'update different user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' },
        { user: second_suspended_user, type: 'second_suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        patch :update, id: u[:user], user: user_params
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt update when not logged in' do
    it 'fail and redirect to log in page' do
      patch :update, id: user, user: user_params
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update user and admin status (via web request)' do
    before(:each) do
      user_params[:admin_attributes] = { _destroy: '0' }
    end

    it 'as super-admin user: user updated but admin status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: user, user: user_params }.to change { Admin.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not updated nor admin status assigned; redirect to log in page' do
      expect { patch :update, id: user, user: user_params }.to change { Admin.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update user and super-admin status (via web request)' do
    before(:each) do
      user_params[:super_admin_attributes] = { _destroy: '0' }
    end

    it 'as super-admin user: user updated but super-admin status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: user, user: user_params }.to change { SuperAdmin.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not updated nor super-admin status assigned; redirect to log in page' do
      expect { patch :update, id: user, user: user_params }.to change { SuperAdmin.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update user and suspension status (via web request)' do
    before(:each) do
      user_params[:suspension_attributes] = { _destroy: '0' }
    end

    it 'as super-admin user: user updated but suspended status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: user, user: user_params }.to change { Suspension.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not updated nor suspended status assigned; redirect to log in page' do
      expect { patch :update, id: user, user: user_params }.to change { Suspension.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'permitted user update' do
    it 'will remove leading and trailing whitespace' do
      session[:user_id] = user.id
      patch :update, id: user, user: whitespace_user_params
      user.reload
      expect(user.name).to eq user_attrs[:name]
      expect(user.email).to eq user_attrs[:email]
    end

    it 'with valid params will retain existing creator association and update updater association (w/itself)' do
      session[:user_id] = user_with_creator.id
      patch :update, id: user_with_creator, user: user_params
      user_with_creator.reload
      expect(user_with_creator.creator).to eq user_creator
      expect(user_with_creator.updater).to eq user_with_creator
      expect(user_creator.created_users).to include user_with_creator
      expect(user_creator.updated_users).not_to include user_with_creator
      expect(user_with_creator.created_users).not_to include user_with_creator
      expect(user_with_creator.updated_users).to include user_with_creator
    end

    it 'with invalid params will retain existing creator association and update updater associations' do
      session[:user_id] = user_with_creator.id
      patch :update, id: user_with_creator, user: { name: '', email: '' }
      user_with_creator.reload
      expect(user_with_creator.creator).to eq user_creator
      expect(user_with_creator.updater).to eq user_creator
      expect(user_creator.created_users).to include user_with_creator
      expect(user_creator.updated_users).to include user_with_creator
      expect(user_with_creator.created_users).not_to include user_with_creator
      expect(user_with_creator.updated_users).not_to include user_with_creator
    end
  end
end
