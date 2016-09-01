require 'rails_helper'

describe AdminStatusController, type: :controller do
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

  context 'attempt admin status update as super-admin user' do
    it 'update admin status of unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', destroy: '0', id: nil, count: 0, response: root_path },
        { user: second_super_admin_user, type: 'second_super_admin_user', destroy: '0', id: nil, count: 0, response: root_path },
        { user: admin_user, type: 'admin_user', destroy: '1', id: admin_user.id, count: -1, response: admin_user },
        { user: user, type: 'user', destroy: '0', id: nil, count: 1, response: user }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by u[:count]
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end

    it 'update admin status of suspended user types: various responses' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', destroy: '0', id: nil, count: 0, response: root_path },
        { user: suspended_admin_user, type: 'suspended_admin_user', destroy: '1', id: suspended_admin_user.id, count: -1, response: suspended_admin_user },
        { user: suspended_user, type: 'suspended_user', destroy: '0', id: nil, count: 1, response: suspended_user }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by u[:count]
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status update as suspended super-admin user' do
    it 'update admin status of unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user', destroy: '0', id: nil },
        { user: admin_user, type: 'admin_user', destroy: '1', id: admin_user.id },
        { user: user, type: 'user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', destroy: '0', id: nil },
        { user: second_suspended_super_admin_user, type: 'second_suspended_super_admin_user', destroy: '0', id: nil },
        { user: suspended_admin_user, type: 'suspended_admin_user', destroy: '1', id: suspended_admin_user.id },
        { user: suspended_user, type: 'suspended_user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status update as admin user' do
    it 'update admin status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user', destroy: '0', id: nil },
        { user: admin_user, type: 'admin_user', destroy: '1', id: admin_user.id },
        { user: second_admin_user, type: 'second_admin_user', destroy: '1', id: second_admin_user.id },
        { user: user, type: 'user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', destroy: '0', id: nil },
        { user: suspended_admin_user, type: 'suspended_admin_user', destroy: '1', id: suspended_admin_user.id },
        { user: suspended_user, type: 'suspended_user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status update as suspended admin user' do
    it 'update admin status of unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user', destroy: '0', id: nil },
        { user: admin_user, type: 'admin_user', destroy: '1', id: admin_user.id },
        { user: user, type: 'user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', destroy: '0', id: nil },
        { user: suspended_admin_user, type: 'suspended_admin_user', destroy: '1', id: suspended_admin_user.id },
        { user: second_suspended_admin_user, type: 'second_suspended_admin_user', destroy: '1', id: second_suspended_admin_user.id },
        { user: suspended_user, type: 'suspended_user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status update as non-admin user' do
    it 'update admin status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user', destroy: '0', id: nil },
        { user: admin_user, type: 'admin_user', destroy: '1', id: admin_user.id },
        { user: user, type: 'user', destroy: '0', id: nil },
        { user: second_user, type: 'second_user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', destroy: '0', id: nil },
        { user: suspended_admin_user, type: 'suspended_admin_user', destroy: '1', id: suspended_admin_user.id },
        { user: suspended_user, type: 'suspended_user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status update as suspended non-admin user' do
    it 'update admin status of unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user', destroy: '0', id: nil },
        { user: admin_user, type: 'admin_user', destroy: '1', id: admin_user.id },
        { user: user, type: 'user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'update admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', destroy: '0', id: nil },
        { user: suspended_admin_user, type: 'suspended_admin_user', destroy: '1', id: suspended_admin_user.id },
        { user: suspended_user, type: 'suspended_user', destroy: '0', id: nil },
        { user: second_suspended_user, type: 'second_suspended_user', destroy: '0', id: nil }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        expect { patch :update, user_id: u[:user], user: { admin_attributes: { _destroy: u[:destroy], id: u[:id] } } }.to change { Admin.count }.by 0
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status update (assign status) when not logged in' do
    it 'fail and redirect to log in page' do
      expect { patch :update, user_id: user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'permitted admin status update' do
    it 'assign status: assignor and assignee associations created' do
      session[:user_id] = super_admin_user.id
      patch :update, user_id: user, user: { admin_attributes: { _destroy: '0' } }
      expect(user.admin_status_assignor).to eq super_admin_user
      expect(super_admin_user.admin_status_assignees).to include user
    end

    it 'revoke status: assignor and assignee associations destroyed' do
      session[:user_id] = super_admin_user.id
      patch :update, user_id: admin_user, user: { admin_attributes: { _destroy: '1', id: admin_user.id } }
      expect(admin_user.admin_status_assignor).to eq nil
      expect(super_admin_user.admin_status_assignees).to be_empty
    end
  end

  context 'attempt super-admin status update (via web request)' do
    it 'as super-admin user: update super-admin status of user: fail but response as expected' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to user
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { patch :update, user_id: user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end
end
