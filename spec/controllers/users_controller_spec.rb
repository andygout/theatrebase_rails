require 'rails_helper'

describe UsersController, type: :controller do
  let!(:user) { create :user }
  let(:second_user) { create :second_user }
  let(:third_user) { attributes_for :third_user }
  let!(:admin_user) { create :admin_user }
  let!(:second_admin_user) { create :second_admin_user }

  context 'attempt add new user' do
    it 'when logged in as admin' do
      session[:user_id] = admin_user.id
      get :new
      expect(response).to render_template(:new)
    end

    it 'when logged in as non-admin' do
      session[:user_id] = user.id
      get :new
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt create new user' do
    it 'when logged in as admin' do
      session[:user_id] = admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 1
      expect(response).to redirect_to root_path
    end

    it 'when logged in as non-admin' do
      session[:user_id] = user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt edit' do
    it 'when not logged in: redirect to login page' do
      get :edit, id: user
      expect(response).to redirect_to login_path
    end
  end

  context 'attempt edit when logged in as admin' do
    it 'edit other admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      get :edit, id: second_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit non-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      get :edit, id: user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt edit when logged in as non-admin' do
    it 'edit admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit other non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: second_user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update' do
    it 'when not logged in: redirect to login page' do
      patch :update, id: user, user: { name: user.name, email: user.email }
      expect(response).to redirect_to login_path
    end
  end

  context 'attempt update when logged in as admin' do
    it 'update other admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: second_admin_user, user: { name: second_admin_user.name, email: second_admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update non-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: user, user: { name: user.name, email: user.email }
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update when logged in as non-admin' do
    it 'update admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: admin_user, user: { name: admin_user.name, email: admin_user.email }
      expect(response).to redirect_to root_path
    end

    it 'update other non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: second_user, user: { name: second_user.name, email: second_user.email }
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt to assign non-admin user as admin via update web request' do
    it 'will not update admin status' do
      session[:user_id] = user.id
      expect { patch :update, id: user, user: { name: user.name, email: user.email, admin_attributes: { user_id: user.id } } }.to change { Admin.count }.by 0
    end
  end

  context 'attempt to visit index when not logged in' do
    it 'redirect to login page' do
      get :index
      expect(response).to redirect_to login_path
    end
  end

  context 'attempt to visit index when logged in as non-admin' do
    it 'redirect to home page' do
      session[:user_id] = user.id
      get :index
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt delete when not logged in' do
    it 'redirect to home page' do
      expect { delete :destroy, id: user }.to change { User.count }.by 0
      expect(response).to redirect_to login_path
    end
  end

  context 'attempt delete when logged in as admin' do
    it 'delete other admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, id: second_admin_user }.to change { User.count }.by(0)
                                                      .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt delete when logged in as non-admin' do
    it 'delete other non-admin user: fail and redirect to home page' do
      session[:user_id] = second_user.id
      expect { delete :destroy, id: user }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'delete admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, id: admin_user }.to change { User.count }.by(0)
                                               .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end
  end
end
