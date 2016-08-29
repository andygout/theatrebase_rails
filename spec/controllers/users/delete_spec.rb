require 'rails_helper'

describe UsersController, type: :controller do
  let!(:super_admin_user) { create :super_admin_user }
  let!(:second_super_admin_user) { create :second_super_admin_user }
  let!(:admin_user) { create :admin_user }
  let!(:second_admin_user) { create :second_admin_user }
  let!(:user) { create :user }
  let!(:second_user) { create :user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:second_suspended_super_admin_user) { create :second_suspended_super_admin_user }
  let(:second_suspended_admin_user) { create :second_suspended_admin_user }
  let(:second_suspended_user) { create :second_suspended_user }

  context 'attempt delete as super-admin user' do
    it 'delete unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', user_count: 0, admin_count: 0, response: root_path },
        { user: second_super_admin_user, type: 'second_super_admin_user', user_count: 0, admin_count: 0, response: root_path },
        { user: admin_user, type: 'admin_user', user_count: -1, admin_count: -1, response: users_path },
        { user: user, type: 'user', user_count: -1, admin_count: 0, response: users_path }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(u[:user_count])
          .and change { Admin.count }.by(u[:admin_count])
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end

    it 'delete suspended user types: various responses' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', user_count: 0, admin_count: 0, response: root_path },
        { user: suspended_admin_user, type: 'suspended_admin_user', user_count: -1, admin_count: -1, response: users_path },
        { user: suspended_user, type: 'suspended_user', user_count: -1, admin_count: 0, response: users_path }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(u[:user_count])
          .and change { Admin.count }.by(u[:admin_count])
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt delete as suspended super-admin user' do
    it 'delete unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(0)
          .and change { Admin.count }.by(0)
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'delete suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: second_suspended_super_admin_user, type: 'second_suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(0)
          .and change { Admin.count }.by(0)
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt delete as admin user' do
    it 'delete unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', user_count: 0, admin_count: 0, response: root_path },
        { user: admin_user, type: 'admin_user', user_count: -1, admin_count: -1, response: root_path },
        { user: second_admin_user, type: 'second_admin_user', user_count: 0, admin_count: 0, response: root_path },
        { user: user, type: 'user', user_count: -1, admin_count: 0, response: users_path }
      ].each do |u|
        session[:user_id] = admin_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(u[:user_count])
          .and change { Admin.count }.by(u[:admin_count])
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end

    it 'delete suspended user types: various responses' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', user_count: 0, admin_count: 0, response: root_path },
        { user: suspended_admin_user, type: 'suspended_admin_user', user_count: 0, admin_count: 0, response: root_path },
        { user: suspended_user, type: 'suspended_user', user_count: -1, admin_count: 0, response: users_path }
      ].each do |u|
        session[:user_id] = admin_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(u[:user_count])
          .and change { Admin.count }.by(u[:admin_count])
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(u[:response]), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt delete as suspended admin user' do
    it 'delete unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(0)
          .and change { Admin.count }.by(0)
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'delete suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: second_suspended_admin_user, type: 'second_suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(0)
          .and change { Admin.count }.by(0)
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt delete as non-admin user' do
    it 'delete unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', user_count: 0 },
        { user: admin_user, type: 'admin_user', user_count: 0 },
        { user: user, type: 'user', user_count: -1 },
        { user: second_user, type: 'second_user', user_count: 0 }
      ].each do |u|
        session[:user_id] = user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(u[:user_count])
          .and change { Admin.count }.by(0)
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'delete suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(0)
          .and change { Admin.count }.by(0)
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt delete as suspended non-admin user' do
    it 'delete unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(0)
          .and change { Admin.count }.by(0)
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'delete suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' },
        { user: second_suspended_user, type: 'second_suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        expect { delete :destroy, id: u[:user] }
          .to change { User.count }.by(0)
          .and change { Admin.count }.by(0)
          .and change { SuperAdmin.count }.by(0)
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt delete when not logged in' do
    it 'redirect to log in page' do
      expect { delete :destroy, id: user }.to change { User.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end
end
