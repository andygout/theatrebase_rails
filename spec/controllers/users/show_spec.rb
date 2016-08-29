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

  context 'attempt show user display page as super-admin user' do
    it 'show unsuspended user types: render user display page for self and users of a lower rank' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: render_template(:show) },
        { user: second_super_admin_user, type: 'second_super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: render_template(:show) },
        { user: user, type: 'user', response: render_template(:show) }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        get :show, id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'show suspended user types: render user display page for users of a lower rank' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', response: redirect_to(root_path) },
        { user: suspended_admin_user, type: 'suspended_admin_user', response: render_template(:show) },
        { user: suspended_user, type: 'suspended_user', response: render_template(:show) }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        get :show, id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt show user display page as suspended super-admin user' do
    it 'show unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        get :show, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'show suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: second_suspended_super_admin_user, type: 'second_suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        get :show, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt show user display page as admin user' do
    it 'show unsuspended user types: render user display page for self and users of a lower rank' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: render_template(:show) },
        { user: second_admin_user, type: 'second_admin_user', response: redirect_to(root_path) },
        { user: user, type: 'user', response: render_template(:show) }
      ].each do |u|
        session[:user_id] = admin_user.id
        get :show, id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'show suspended user types: render user display page for users of a lower rank' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', response: redirect_to(root_path) },
        { user: suspended_admin_user, type: 'suspended_admin_user', response: redirect_to(root_path) },
        { user: suspended_user, type: 'suspended_user', response: render_template(:show) }
      ].each do |u|
        session[:user_id] = admin_user.id
        get :show, id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt show user display page as suspended admin user' do
    it 'show unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        get :show, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'show suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: second_suspended_admin_user, type: 'second_suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        get :show, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt show user display page as non-admin user' do
    it 'show unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: redirect_to(root_path) },
        { user: user, type: 'user', response: render_template(:show) },
        { user: second_user, type: 'second_user', response: redirect_to(root_path) }
      ].each do |u|
        session[:user_id] = user.id
        get :show, id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'show suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = user.id
        get :show, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt show user display page as suspended non-admin user' do
    it 'show unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        get :show, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'show suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' },
        { user: second_suspended_user, type: 'second_suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        get :show, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt show user page when not logged in' do
    it 'redirect to log in page' do
      get :show, id: user
      expect(response).to redirect_to log_in_path
    end
  end
end
