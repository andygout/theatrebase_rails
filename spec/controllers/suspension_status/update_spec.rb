require 'rails_helper'

describe SuspensionStatusController, type: :controller do
  let(:super_admin_user) { create :super_admin_user }
  let(:second_super_admin_user) { create :second_super_admin_user }
  let(:admin_user) { create :admin_user }
  let(:second_admin_user) { create :second_admin_user }
  let(:user) { create :user }
  let(:second_user) { create :user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:second_suspended_super_admin_user) { create :second_suspended_super_admin_user }
  let(:second_suspended_admin_user) { create :second_suspended_admin_user }
  let(:second_suspended_user) { create :second_suspended_user }

  context 'attempt suspension status update as super-admin user' do
    it 'update suspension status of unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', count: 0, response: root_path },
        { user: second_super_admin_user, type: 'second_super_admin_user', count: 0, response: root_path },
        { user: admin_user, type: 'admin_user', count: 1, response: admin_user },
        { user: user, type: 'user', count: 1, response: user }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by u[:count]
        expect(response).to redirect_to u[:response]
      end
    end

    it 'update suspension status of suspended user types: various responses' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', count: 0, response: root_path },
        { user: suspended_admin_user, type: 'suspended_admin_user', count: -1, response: suspended_admin_user },
        { user: suspended_user, type: 'suspended_user', count: -1, response: suspended_user }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '1', id: u[:user].id } } }.to change { Suspension.count }.by u[:count]
        expect(response).to redirect_to u[:response]
      end
    end
  end

  context 'attempt suspension status update as suspended super-admin user' do
    it 'update suspension status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update suspension status of suspended user types: all fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: second_suspended_super_admin_user, type: 'second_suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '1', id: u[:user].id } } }.to change { Suspension.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status update as admin user' do
    it 'update suspension status of unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', count: 0, response: root_path },
        { user: admin_user, type: 'admin_user', count: 0, response: root_path },
        { user: second_admin_user, type: 'second_admin_user', count: 0, response: root_path },
        { user: user, type: 'user', count: 1, response: user }
      ].each do |u|
        session[:user_id] = admin_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by u[:count]
        expect(response).to redirect_to u[:response]
      end
    end

    it 'update suspension status of suspended user types: various responses' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', count: 0, response: root_path },
        { user: suspended_admin_user, type: 'suspended_admin_user', count: 0, response: root_path },
        { user: suspended_user, type: 'suspended_user', count: -1, response: suspended_user }
      ].each do |u|
        session[:user_id] = admin_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '1', id: u[:user].id } } }.to change { Suspension.count }.by u[:count]
        expect(response).to redirect_to u[:response]
      end
    end
  end

  context 'attempt suspension status update as suspended admin user' do
    it 'update suspension status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update suspension status of suspended user types: all fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: second_suspended_admin_user, type: 'second_suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '1', id: u[:user].id } } }.to change { Suspension.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status update as non-admin user' do
    it 'update suspension status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' },
        { user: second_user, type: 'second_user' }
      ].each do |u|
        session[:user_id] = user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update suspension status of suspended user types: all fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '1', id: u[:user].id } } }.to change { Suspension.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status update as suspended non-admin user' do
    it 'update suspension status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update suspension status of suspended user types: all fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' },
        { user: second_suspended_user, type: 'second_suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        expect { patch :update, user_id: u[:user], user: { suspension_attributes: { _destroy: '1', id: u[:user].id } } }.to change { Suspension.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status update (assign status) when not logged in' do
    it 'fail and redirect to log in page' do
      expect { patch :update, user_id: user, user: { suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'permitted suspension status update' do
    it 'assign status: assignor and assignee associations created' do
      session[:user_id] = super_admin_user.id
      patch :update, user_id: user, user: { suspension_attributes: { _destroy: '0' } }
      expect(user.suspension_status_assignor).to eq super_admin_user
      expect(super_admin_user.suspension_status_assignees).to include user
    end

    it 'revoke status: assignor and assignee associations destroyed' do
      session[:user_id] = super_admin_user.id
      patch :update, user_id: suspended_user, user: { suspension_attributes: { _destroy: '1', id: suspended_user.id } }
      expect(suspended_user.suspension_status_assignor).to eq nil
      expect(super_admin_user.suspension_status_assignees).to be_empty
    end
  end

  context 'logged in as user whose account is suspended' do
    it 'user will be logged out on first page request following suspension' do
      session[:user_id] = user.id
      Suspension.create(user_id: user.id, assignor_id: super_admin_user.id)
      expect(session[:user_id]).to eq user.id
      get :edit, user_id: user
      expect(session[:user_id]).to be nil
      expect(response).to redirect_to root_path
    end
  end
end
