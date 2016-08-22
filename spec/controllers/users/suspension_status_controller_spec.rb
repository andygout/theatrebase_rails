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

  context 'attempt create user with suspended status' do
    it 'via suspension status create route: fail as not routable' do
      expect(post: '/suspension status' ).not_to be_routable
    end
  end

  context 'attempt suspension status edit as super-admin user' do
    it 'edit suspension status of unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: redirect_to(root_path) },
        { user: second_super_admin_user, type: 'second_super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: render_template(:edit) },
        { user: user, type: 'user', response: render_template(:edit) }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'edit suspension status of suspended user types: various responses' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', response: redirect_to(root_path) },
        { user: suspended_admin_user, type: 'suspended_admin_user', response: render_template(:edit) },
        { user: suspended_user, type: 'suspended_user', response: render_template(:edit) }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status edit as suspended super-admin user' do
    it 'edit suspension status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit suspension status of suspended user types: all fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: second_suspended_super_admin_user, type: 'second_suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status edit as admin user' do
    it 'edit suspension status of unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: redirect_to(root_path) },
        { user: second_admin_user, type: 'second_admin_user', response: redirect_to(root_path) },
        { user: user, type: 'user', response: render_template(:edit) }
      ].each do |u|
        session[:user_id] = admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'edit suspension status of suspended user types: various responses' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', response: redirect_to(root_path) },
        { user: suspended_admin_user, type: 'suspended_admin_user', response: redirect_to(root_path) },
        { user: suspended_user, type: 'suspended_user', response: render_template(:edit) }
      ].each do |u|
        session[:user_id] = admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status edit as suspended admin user' do
    it 'edit suspension status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit suspension status of suspended user types: all fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: second_suspended_admin_user, type: 'second_suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status edit as non-admin user' do
    it 'edit suspension status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' },
        { user: second_user, type: 'second_user' }
      ].each do |u|
        session[:user_id] = user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit suspension status of suspended user types: all fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status edit as suspended non-admin user' do
    it 'edit suspension status of unsuspended user types: all fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit suspension status of suspended user types: all fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' },
        { user: second_suspended_user, type: 'second_suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt suspension status edit when not logged in' do
    it 'fail and redirect to log in page' do
      get :edit, user_id: user
      expect(response).to redirect_to log_in_path
    end
  end

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

  context 'attempt suspension status update when not logged in' do
    it 'fail and redirect to log in page' do
      expect { patch :update, user_id: user, user: { suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by 0
      expect(response).to redirect_to log_in_path
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
