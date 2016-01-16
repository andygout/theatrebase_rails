require 'rails_helper'

describe AdminStatusController, type: :controller do
  let!(:super_admin_user) { create :super_admin_user }
  let!(:second_super_admin_user) { create :second_super_admin_user }
  let!(:admin_user) { create :admin_user }
  let!(:second_admin_user) { create :second_admin_user }
  let!(:user) { create :user }
  let(:second_user) { create :second_user }
  let(:third_user) { attributes_for :third_user }

  context 'attempt to create user with admin status via create web request; fail and redirect to user display page' do
    it 'attempt to create new user via admin status create route' do
      expect(post: '/admin status' ).not_to be_routable
    end
  end

  context 'attempt admin status edit when logged in as super-admin user' do
    it 'edit admin status of self (super-admin user): fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      get :edit, id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of other super-admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      get :edit, id: second_super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of admin user: succeed and render admin user edit form' do
      session[:user_id] = super_admin_user.id
      get :edit, id: admin_user
      expect(response).to render_template(:edit)
    end

    it 'edit admin status of non-admin user: succeed and render non-admin user edit form' do
      session[:user_id] = super_admin_user.id
      get :edit, id: user
      expect(response).to render_template(:edit)
    end
  end

  context 'attempt admin status edit when logged in as admin user' do
    it 'edit admin status of super-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      get :edit, id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of self (admin user): fail and redirect to home page' do
      session[:user_id] = admin_user.id
      get :edit, id: admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of other admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      get :edit, id: second_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of non-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      get :edit, id: user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt admin status edit when logged in as non-admin user' do
    it 'edit admin status of super-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of self (non-admin user): fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of other non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: second_user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt admin status edit when not logged in' do
    it 'fail and redirect to log in page' do
      get :edit, id: user
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt admin status update when logged in as super-admin user' do
    it 'update admin status of self (super-admin user): fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: super_admin_user, user: { name: super_admin_user.name, email: super_admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update admin status of other super-admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: second_super_admin_user, user: { name: second_super_admin_user.name, email: second_super_admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update admin status of other admin user: succeed and redirect to adminuser display page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: admin_user, user: { name: admin_user.name, email: admin_user.email }
      expect(response).to redirect_to user_path(admin_user)
    end

    it 'update admin status of non-admin user: succeed and redirect to non-admin user display page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: user, user: { name: user.name, email: user.email }
      expect(response).to redirect_to user_path(user)
    end
  end

  context 'attempt admin status update when logged in as admin user' do
    it 'update admin status of super-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: super_admin_user, user: { name: super_admin_user.name, email: super_admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update admin status of self (admin user): fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: admin_user, user: { name: admin_user.name, email: admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update admin status of other admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: second_admin_user, user: { name: second_admin_user.name, email: second_admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update admin status of non-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: user, user: { name: user.name, email: user.email }
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt admin status update when logged in as non-admin user' do
    it 'update admin status of super-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: super_admin_user, user: { name: super_admin_user.name, email: super_admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update admin status of admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: admin_user, user: { name: admin_user.name, email: admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update admin status of self (non-admin user): fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: user, user: { name: user.name, email: user.email }
      expect(response).to redirect_to root_path
    end

    it 'update admin status of other non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: second_user, user: { name: second_user.name, email: second_user.email }
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt admin status update when not logged in' do
    it 'fail and redirect to log in page' do
      patch :update, id: user, user: { name: user.name, email: user.email }
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt to assign admin status to user via update web request; all fail and redirect to user display page' do
    it 'attempt to assign non-admin user admin status' do
      session[:user_id] = user.id
      expect { patch :update, id: user, user: { admin_attributes: { status: true } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'attempt to assign non-admin user super-admin status' do
      session[:user_id] = user.id
      expect { patch :update, id: user, user: { super_admin_attributes: { } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'attempt to assign admin user super-admin status' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: admin_user, user: { super_admin_attributes: { } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end
  end

end
