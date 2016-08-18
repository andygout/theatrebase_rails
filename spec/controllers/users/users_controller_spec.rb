require 'rails_helper'

describe UsersController, type: :controller do
  let!(:super_admin_user) { create :super_admin_user }
  let!(:second_super_admin_user) { create :second_super_admin_user }
  let!(:admin_user) { create :admin_user }
  let!(:second_admin_user) { create :second_admin_user }
  let!(:user) { create :user }
  let(:second_user) { create :second_user }
  let(:third_user) { attributes_for :third_user }
  let(:edit_user) { attributes_for :edit_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:second_suspended_super_admin_user) { create :second_suspended_super_admin_user }
  let(:second_suspended_admin_user) { create :second_suspended_admin_user }
  let(:second_suspended_user) { create :second_suspended_user }

  context 'attempt add new user' do
    it 'as super-admin: render new user form' do
      session[:user_id] = super_admin_user.id
      get :new
      expect(response).to render_template :new
    end

    it 'as admin: render new user form' do
      session[:user_id] = admin_user.id
      get :new
      expect(response).to render_template :new
    end

    it 'as non-admin: fail and redirect to home page' do
      session[:user_id] = user.id
      get :new
      expect(response).to redirect_to root_path
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      get :new
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      get :new
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      get :new
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :new
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user' do
    it 'as super-admin user: succeed and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 1
      expect(response).to redirect_to root_path
    end

    it 'as admin user: succeed and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 1
      expect(response).to redirect_to root_path
    end

    it 'as non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended super-admin user: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin user: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin user: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user with admin status (via web request)' do
    it 'as super-admin user: user created but admin status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], admin_attributes: { _destroy: '0' } } }
        .to change { User.count }.by(1)
        .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not created nor super-admin status assigned; redirect to log in page' do
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], admin_attributes: { _destroy: '0' } } }
        .to change { User.count }.by(0)
        .and change { Admin.count }.by(0)
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user with super-admin status (via web request)' do
    it 'as super-admin user: user created but super-admin status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], super_admin_attributes: { _destroy: '0' } } }
        .to change { User.count }.by(1)
        .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not created nor super-admin status assigned; redirect to log in page' do
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], super_admin_attributes: { _destroy: '0' } } }
        .to change { User.count }.by(0)
        .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user with suspended status (via web request)' do
    it 'as super-admin user: user created but suspended status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], suspension_attributes: { _destroy: '0' } } }
        .to change { User.count }.by(1)
        .and change { Suspension.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not created nor suspended status assigned; redirect to log in page' do
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], suspension_attributes: { _destroy: '0' } } }
        .to change { User.count }.by(0)
        .and change { Suspension.count }.by(0)
      expect(response).to redirect_to log_in_path
    end
  end

  context 'create user with leading and trailing whitespace on name and email' do
    it 'will remove leading and trailing whitespace' do
      session[:user_id] = admin_user.id
      post :create, user: { name: ' ' + third_user[:name] + ' ', email: ' ' + third_user[:email] + ' ' }
      user = User.last
      expect(user.name).to eq third_user[:name]
      expect(user.email).to eq third_user[:email]
    end
  end

  context 'attempt edit as super-admin user' do
    it 'edit unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: render_template(:edit) },
        { user: second_super_admin_user, type: 'second_super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: redirect_to(root_path) },
        { user: user, type: 'user', response: redirect_to(root_path) }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        get :edit, id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'edit suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt edit as suspended super-admin user' do
    it 'edit unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: second_suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt edit as admin user' do
    it 'edit unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: render_template(:edit) },
        { user: second_admin_user, type: 'second_admin_user', response: redirect_to(root_path) },
        { user: user, type: 'user', response: redirect_to(root_path) }
      ].each do |u|
        session[:user_id] = admin_user.id
        get :edit, id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'edit suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = admin_user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt edit as suspended admin user' do
    it 'edit suspended types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: second_suspended_admin_user, type: 'second_suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt edit as non-admin user' do
    it 'edit unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: redirect_to(root_path) },
        { user: user, type: 'user', response: render_template(:edit) },
        { user: second_user, type: 'second_user', response: redirect_to(root_path) }
      ].each do |u|
        session[:user_id] = user.id
        get :edit, id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'edit suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt edit as suspended non-admin user' do
    it 'edit unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' },
        { user: second_suspended_user, type: 'second_suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        get :edit, id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt edit when not logged in' do
    it 'fail and redirect to log in page' do
      get :edit, id: user
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update as super-admin user' do
    it 'update unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', name: edit_user[:name], response: super_admin_user },
        { user: second_super_admin_user, type: 'second_super_admin_user', name: second_super_admin_user.name, response: root_path },
        { user: admin_user, type: 'admin_user', name: admin_user.name, response: root_path },
        { user: user, type: 'user', name: user.name, response: root_path }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt update as admin user' do
    it 'update unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', name: super_admin_user.name, response: root_path },
        { user: admin_user, type: 'admin_user', name: edit_user[:name], response: admin_user },
        { user: second_admin_user, type: 'second_admin_user', name: second_admin_user.name, response: root_path },
        { user: user, type: 'user', name: user.name, response: root_path }
      ].each do |u|
        session[:user_id] = admin_user.id
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        { user: user, type: 'user', name: edit_user[:name], response: user },
        { user: second_user, type: 'second_user', name: second_user.name, response: root_path }
      ].each do |u|
        session[:user_id] = user.id
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
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
        patch :update, id: u[:user], user: { name: edit_user[:name], email: edit_user[:email] }
        expect(u[:user].name).to eq u[:user].reload.name
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt update when not logged in' do
    it 'fail and redirect to log in page' do
      patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update user and admin status (via web request)' do
    it 'as super-admin user: user updated but admin status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not updated nor admin status assigned; redirect to log in page' do
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update user and super-admin status (via web request)' do
    it 'as super-admin user: user updated but super-admin status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not updated nor super-admin status assigned; redirect to log in page' do
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update user and suspension status (via web request)' do
    it 'as super-admin user: user updated but suspended status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not updated nor suspended status assigned; redirect to log in page' do
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], suspension_attributes: { _destroy: '0' } } }.to change { Suspension.count }.by 0
      expect(user.name).to eq user.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'update user with leading and trailing whitespace on name and email' do
    it 'will remove leading and trailing whitespace' do
      session[:user_id] = user.id
      patch :update, id: user, user: { name: ' ' + third_user[:name] + ' ', email: ' ' + third_user[:email] + ' ' }
      user.reload
      expect(user.name).to eq third_user[:name]
      expect(user.email).to eq third_user[:email]
    end
  end

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

  context 'attempt view user index' do
    it 'as super-admin user: render user index' do
      session[:user_id] = super_admin_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as admin user: render user index' do
      session[:user_id] = admin_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'as suspended super-admin user: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin user: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin user: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :index
      expect(response).to redirect_to log_in_path
    end
  end
end