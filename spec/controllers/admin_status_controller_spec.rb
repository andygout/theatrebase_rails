require 'rails_helper'

describe AdminStatusController, type: :controller do
  let!(:super_admin_user) { create :super_admin_user }
  let!(:second_super_admin_user) { create :second_super_admin_user }
  let!(:admin_user) { create :admin_user }
  let!(:second_admin_user) { create :second_admin_user }
  let(:user) { create :user }
  let(:second_user) { create :second_user }

  context 'attempt to create user with admin status; fail and redirect to user display page' do
    it 'attempt to create new user via admin status create route (not routable)' do
      expect(post: '/admin status' ).not_to be_routable
    end
  end

  context 'attempt admin status edit when logged in as super-admin user' do
    it 'edit admin status of self (super-admin user): fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      get :edit, user_id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of other super-admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      get :edit, user_id: second_super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of admin user: succeed and render admin user edit form' do
      session[:user_id] = super_admin_user.id
      get :edit, user_id: admin_user.id
      expect(response).to render_template(:edit)
    end

    it 'edit admin status of non-admin user: succeed and render non-admin user edit form' do
      session[:user_id] = super_admin_user.id
      get :edit, user_id: user
      expect(response).to render_template(:edit)
    end
  end

  context 'attempt admin status edit when logged in as admin user; all fail and redirect to home page' do
    it 'edit admin status of super-admin user' do
      session[:user_id] = admin_user.id
      get :edit, user_id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of self (admin user)' do
      session[:user_id] = admin_user.id
      get :edit, user_id: admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of other admin user' do
      session[:user_id] = admin_user.id
      get :edit, user_id: second_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of non-admin user' do
      session[:user_id] = admin_user.id
      get :edit, user_id: user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt admin status edit when logged in as non-admin user; all fail and redirect to home page' do
    it 'edit admin status of super-admin user' do
      session[:user_id] = user.id
      get :edit, user_id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of admin user' do
      session[:user_id] = user.id
      get :edit, user_id: admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of self (non-admin user)' do
      session[:user_id] = user.id
      get :edit, user_id: user
      expect(response).to redirect_to root_path
    end

    it 'edit admin status of other non-admin user' do
      session[:user_id] = user.id
      get :edit, user_id: second_user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt admin status edit when not logged in' do
    it 'fail and redirect to log in page' do
      get :edit, user_id: user
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt admin status update when logged in as super-admin user' do
    it 'update admin status of self (super-admin user) (assign status): fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: super_admin_user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update admin status of other super-admin user (assign status): fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: second_super_admin_user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update admin status of admin user (revoke status): succeed and redirect to admin user display page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: admin_user, user: { admin_attributes: { _destroy: '1', id: admin_user.id } } }.to change { Admin.count }.by -1
      expect(response).to redirect_to user_path(admin_user)
    end

    it 'update admin status of non-admin user (assign status): succeed and redirect to non-admin user display page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 1
      expect(response).to redirect_to user_path(user)
    end
  end

  context 'attempt admin status update when logged in as admin user; all fail and redirect to home page' do
    it 'update admin status of super-admin user (assign status)' do
      session[:user_id] = admin_user.id
      expect { patch :update, user_id: super_admin_user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update admin status of self (admin user) (revoke status)' do
      session[:user_id] = admin_user.id
      expect { patch :update, user_id: admin_user, user: { admin_attributes: { _destroy: '1', id: admin_user.id } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update admin status of other admin user (revoke status)' do
      session[:user_id] = admin_user.id
      expect { patch :update, user_id: second_admin_user, user: { admin_attributes: { _destroy: '1', id: second_admin_user.id } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update admin status of non-admin user (assign status)' do
      session[:user_id] = admin_user.id
      expect { patch :update, user_id: user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt admin status update when logged in as non-admin user; all fail and redirect to home page' do
    it 'update admin status of super-admin user (assign status)' do
      session[:user_id] = user.id
      expect { patch :update, user_id: super_admin_user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update admin status of admin user (revoke status)' do
      session[:user_id] = user.id
      expect { patch :update, user_id: admin_user, user: { admin_attributes: { _destroy: '1', id: admin_user.id } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update admin status of self (non-admin user) (assign status)' do
      session[:user_id] = user.id
      expect { patch :update, user_id: user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update admin status of other non-admin user (assign status)' do
      session[:user_id] = user.id
      expect { patch :update, user_id: second_user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt admin status update (assign status) when not logged in' do
    it 'fail and redirect to log in page' do
      expect { patch :update, user_id: user, user: { admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt super-admin status update when logged in as super-admin user' do
    it 'update super-admin status of self (super-admin user) (revoke status): fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: super_admin_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '1', id: super_admin_user.id } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update super-admin status of other super-admin user (revoke status): fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: second_super_admin_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '1', id: second_super_admin_user.id } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update super-admin status of admin user (assign status): super-admin status not updated and redirect to user display page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: admin_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to user_path(admin_user)
    end

    it 'update super-admin status of non-admin user (assign status): super-admin status not updated and redirect to user display page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, user_id: user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to user_path(user)
    end
  end

  context 'attempt super-admin status update when logged in as admin user; all fail and redirect to home page' do
    it 'update super-admin status of super-admin user (revoke status)' do
      session[:user_id] = admin_user.id
      expect { patch :update, user_id: super_admin_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '1', id: super_admin_user.id } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update super-admin status of self (admin user) (assign status)' do
      session[:user_id] = admin_user.id
      expect { patch :update, user_id: admin_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update super-admin status of other admin user (assign status)' do
      session[:user_id] = admin_user.id
      expect { patch :update, user_id: second_admin_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update super-admin status of non-admin user (assign status)' do
      session[:user_id] = admin_user.id
      expect { patch :update, user_id: user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt super-admin status update when logged in as non-admin user; all fail and redirect to home page' do
    it 'update super-admin status of super-admin user (revoke status)' do
      session[:user_id] = user.id
      expect { patch :update, user_id: super_admin_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '1', id: super_admin_user.id } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update super-admin status of admin user (assign status)' do
      session[:user_id] = user.id
      expect { patch :update, user_id: second_admin_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update super-admin status of self (non-admin user) (assign status)' do
      session[:user_id] = user.id
      expect { patch :update, user_id: user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'update super-admin status of other non-admin user (assign status)' do
      session[:user_id] = user.id
      expect { patch :update, user_id: second_user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt super-admin status update when not logged in' do
    it 'fail and redirect to log in page' do
      expect { patch :update, user_id: user, user: { admin_attributes: { }, super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end
end
