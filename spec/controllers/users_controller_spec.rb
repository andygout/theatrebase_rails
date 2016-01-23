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

  context 'attempt add new user' do
    it 'when logged in as super-admin: render new user form' do
      session[:user_id] = super_admin_user.id
      get :new
      expect(response).to render_template(:new)
    end

    it 'when logged in as admin: render new user form' do
      session[:user_id] = admin_user.id
      get :new
      expect(response).to render_template(:new)
    end

    it 'when logged in as non-admin: fail and redirect to home page' do
      session[:user_id] = user.id
      get :new
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :new
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user' do
    it 'when logged in as super-admin user: succeed and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 1
      expect(response).to redirect_to root_path
    end

    it 'when logged in as admin user: succeed and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 1
      expect(response).to redirect_to root_path
    end

    it 'when logged in as non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { post :create, user: { name: third_user[:name], email: third_user[:email] } }.to change { User.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user with admin status' do
    it 'when logged in as super-admin user: user created but admin status not assigned; redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], admin_attributes: { _destroy: '0' } } }.to change { User.count }.by(1)
                            .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when logged in as admin user: user created but admin status not assigned; redirect to home page' do
      session[:user_id] = admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], admin_attributes: { _destroy: '0' } } }.to change { User.count }.by(1)
                            .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when logged in as non-admin user: user not created nor admin status assigned; redirect to home page' do
      session[:user_id] = user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], admin_attributes: { _destroy: '0' } } }.to change { User.count }.by(0)
                            .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not created nor admin status assigned; redirect to log in page' do
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], admin_attributes: { _destroy: '0' } } }.to change { User.count }.by(0)
                            .and change { Admin.count }.by(0)
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user with super-admin status' do
    it 'when logged in as super-admin user: user created but super-admin status not assigned; redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { User.count }.by(1)
                                                    .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when logged in as admin user: user created but super-admin status not assigned; redirect to home page' do
      session[:user_id] = admin_user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { User.count }.by(1)
                                                    .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when logged in as non-admin user: user not created nor super-admin status assigned; redirect to home page' do
      session[:user_id] = user.id
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { User.count }.by(0)
                                                    .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not created nor super-admin status assigned; redirect to log in page' do
      expect { post :create, user: { name: third_user[:name], email: third_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { User.count }.by(0)
                                                    .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt edit when logged in as super-admin user' do
    it 'edit self (super-admin user): succeed and render user edit form' do
      session[:user_id] = super_admin_user.id
      get :edit, id: super_admin_user
      expect(response).to render_template(:edit)
    end

    it 'edit other super-admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      get :edit, id: second_super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      get :edit, id: admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit non-admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      get :edit, id: user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt edit when logged in as admin user' do
    it 'edit super-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      get :edit, id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit self (admin user): succeed and render user edit form' do
      session[:user_id] = admin_user.id
      get :edit, id: admin_user
      expect(response).to render_template(:edit)
    end

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

  context 'attempt edit when logged in as non-admin user' do
    it 'edit super-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: admin_user
      expect(response).to redirect_to root_path
    end

    it 'edit self (non-admin user): succeed and render user edit form' do
      session[:user_id] = user.id
      get :edit, id: user
      expect(response).to render_template(:edit)
    end

    it 'edit other non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :edit, id: second_user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt edit when not logged in' do
    it 'fail and redirect to log in page' do
      get :edit, id: user
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update when logged in as super-admin user' do
    it 'update self (super-admin user): succeed and redirect to user display page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(super_admin_user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(super_admin_user)
    end

    it 'update other super-admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: second_super_admin_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(second_super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update other admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update non-admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update when logged in as admin user' do
    it 'update super-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update self (admin user): succeed and redirect to user display page' do
      session[:user_id] = admin_user.id
      patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(admin_user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(admin_user)
    end

    it 'update other admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: second_admin_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(second_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update non-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update when logged in as non-admin user' do
    it 'update super-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update self (non-admin user): succeed and redirect to user display page' do
      session[:user_id] = user.id
      patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(user)
    end

    it 'update other non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      patch :update, id: second_user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(second_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update when not logged in' do
    it 'fail and redirect to log in page' do
      patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email] }
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update user and admin status when logged in as super-admin user' do
    it 'update self (super-admin user): user updated but admin status not assigned; redirect to user display page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(super_admin_user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(super_admin_user)
    end

    it 'update other super-admin user: user not updated nor admin status assigned; redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: second_super_admin_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(second_super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update admin user: user not updated nor admin status revoked; redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '1', id: admin_user.id } } }.to change { Admin.count }.by 0
      expect(admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update non-admin user: user not updated nor admin status assigned; redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update user and admin status when logged in as admin user' do
    it 'update super-admin user: user not updated nor admin status assigned; redirect to home page' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update self (admin user): user updated but admin status not revoked; redirect to user display page' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '1', id: admin_user.id } } }.to change { Admin.count }.by 0
      expect(admin_user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(admin_user)
    end

    it 'update other admin user: user not updated nor admin status revoked; redirect to home page' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: second_admin_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '1', id: admin_user.id } } }.to change { Admin.count }.by 0
      expect(second_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update non-admin user: user not updated nor admin status assigned; redirect to home page' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update user and admin status when logged in as non-admin user' do
    it 'update super-admin user: user not updated nor admin status assigned; redirect to home page' do
      session[:user_id] = user.id
      expect { patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update admin user: user not updated nor admin status revoked; redirect to home page' do
      session[:user_id] = user.id
      expect { patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '1', id: admin_user.id } } }.to change { Admin.count }.by 0
      expect(admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update self (non-admin user): user updated but admin status not assigned; redirect to user display page' do
      session[:user_id] = user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(user)
    end

    it 'update other non-admin user: user not updated nor admin status assigned; redirect to home page' do
      session[:user_id] = user.id
      expect { patch :update, id: second_user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(second_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update user and admin status when not logged in' do
    it 'user not updated nor admin status assigned; redirect to log in page' do
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], admin_attributes: { _destroy: '0' } } }.to change { Admin.count }.by 0
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update user and super-admin status when logged in as super-admin user' do
    it 'update self (super-admin user): user updated but super-admin status not revoked; redirect to user display page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '1', id: super_admin_user.id } } }.to change { SuperAdmin.count }.by 0
      expect(super_admin_user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(super_admin_user)
    end

    it 'update other super-admin user: user not updated nor super-admin status revoked; redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: second_super_admin_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '1', id: second_super_admin_user.id } } }.to change { SuperAdmin.count }.by 0
      expect(second_super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update admin user: user not updated nor super-admin status assigned; redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update non-admin user: user not updated nor super-admin status assigned; redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update user and super-admin status when logged in as admin user' do
    it 'update super-admin user: user not updated nor super-admin status revoked; redirect to home page' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '1', id: super_admin_user.id } } }.to change { SuperAdmin.count }.by 0
      expect(super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update self (admin user): user updated but super-admin status not assigned; redirect to user display page' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(admin_user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(admin_user)
    end

    it 'update other admin user: user not updated nor super-admin status assigned; redirect to home page' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: second_admin_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(second_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update non-admin user: user not updated nor super-admin status assigned; redirect to home page' do
      session[:user_id] = admin_user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update user and super-admin status when logged in as non-admin user' do
    it 'update super-admin user: user not updated nor super-admin status revoked; redirect to home page' do
      session[:user_id] = user.id
      expect { patch :update, id: super_admin_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '1', id: super_admin_user.id } } }.to change { SuperAdmin.count }.by 0
      expect(super_admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update admin user: user not updated nor super-admin status assigned; redirect to home page' do
      session[:user_id] = user.id
      expect { patch :update, id: admin_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(admin_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end

    it 'update self (non-admin user): user updated but super-admin status not assigned; redirect to user display page' do
      session[:user_id] = user.id
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(user.reload.name).to eq edit_user[:name]
      expect(response).to redirect_to user_path(user)
    end

    it 'update other non-admin user: user not updated nor super-admin status assigned; redirect to home page' do
      session[:user_id] = user.id
      expect { patch :update, id: second_user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(second_user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update user and super-admin status when not logged in' do
    it 'user not updated nor super-admin status assigned; redirect to log in page' do
      expect { patch :update, id: user, user: { name: edit_user[:name], email: edit_user[:email], super_admin_attributes: { _destroy: '0' } } }.to change { SuperAdmin.count }.by 0
      expect(user.reload.name).not_to eq edit_user[:name]
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt delete when logged in as super-admin user' do
    it 'delete self (super-admin user): fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { delete :destroy, id: super_admin_user }.to change { User.count }.by(0)
                                                     .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'delete other super-admin user: fail and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { delete :destroy, id: second_super_admin_user }.to change { User.count }.by(0)
                                                            .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'delete admin user: succeed and redirect to user index' do
      session[:user_id] = super_admin_user.id
      expect { delete :destroy, id: admin_user }.to change { User.count }.by(-1)
                                               .and change { Admin.count }.by(-1)
      expect(response).to redirect_to users_path
    end

    it 'delete non-admin user: succeed and redirect to user index' do
      session[:user_id] = super_admin_user.id
      expect { delete :destroy, id: user }.to change { User.count }.by -1
      expect(response).to redirect_to users_path
    end
  end

  context 'attempt delete when logged in as admin user' do
    it 'delete super-admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, id: super_admin_user }.to change { User.count }.by(0)
                                                     .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'delete self (admin user): succeed and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, id: admin_user }.to change { User.count }.by(-1)
                                               .and change { Admin.count }.by(-1)
      expect(response).to redirect_to root_path
    end

    it 'delete other admin user: fail and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, id: second_admin_user }.to change { User.count }.by(0)
                                                      .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'delete non-admin user: succeed and redirect to user index' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, id: user }.to change { User.count }.by -1
      expect(response).to redirect_to users_path
    end
  end

  context 'attempt delete when logged in as non-admin user' do
    it 'delete super-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, id: super_admin_user }.to change { User.count }.by(0)
                                                     .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'delete admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, id: admin_user }.to change { User.count }.by(0)
                                               .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'delete self (non-admin user): succeed and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, id: user }.to change { User.count }.by(-1)
                                         .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'delete other non-admin user: fail and redirect to home page' do
      session[:user_id] = second_user.id
      expect { delete :destroy, id: user }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt delete when not logged in' do
    it 'redirect to log in page' do
      expect { delete :destroy, id: user }.to change { User.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt visit user display page when logged in as super-admin user' do
    it 'visit self (super-admin user): render user display page' do
      session[:user_id] = super_admin_user.id
      get :show, id: super_admin_user
      expect(response).to render_template(:show)
    end

    it 'visit other super-admin: render user display page' do
      session[:user_id] = super_admin_user.id
      get :show, id: second_super_admin_user
      expect(response).to render_template(:show)
    end

    it 'visit admin user: render user display page' do
      session[:user_id] = super_admin_user.id
      get :show, id: admin_user
      expect(response).to render_template(:show)
    end

    it 'visit non-admin user: succeed and render user display page' do
      session[:user_id] = super_admin_user.id
      get :show, id: user
      expect(response).to render_template(:show)
    end
  end

  context 'attempt visit user display page when logged in as admin user' do
    it 'visit super-admin user: render user display page' do
      session[:user_id] = admin_user.id
      get :show, id: super_admin_user
      expect(response).to render_template(:show)
    end

    it 'visit self (admin user): render user display page' do
      session[:user_id] = admin_user.id
      get :show, id: admin_user
      expect(response).to render_template(:show)
    end

    it 'visit other admin user: render user display page' do
      session[:user_id] = admin_user.id
      get :show, id: second_admin_user
      expect(response).to render_template(:show)
    end

    it 'visit non-admin user: succeed and render user display page' do
      session[:user_id] = admin_user.id
      get :show, id: user
      expect(response).to render_template(:show)
    end
  end

  context 'attempt visit user display page when logged in as non-admin user' do
    it 'visit super-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :show, id: super_admin_user
      expect(response).to redirect_to root_path
    end

    it 'visit admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :show, id: admin_user
      expect(response).to redirect_to root_path
    end

    it 'visit self (non-admin user): render user display page' do
      session[:user_id] = user.id
      get :show, id: user
      expect(response).to render_template(:show)
    end

    it 'visit other non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :show, id: second_user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt visit user page when not logged in' do
    it 'redirect to log in page' do
      get :show, id: user
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt visit user index' do
    it 'when logged in as super-admin user: render user index' do
      session[:user_id] = super_admin_user.id
      get :index
      expect(response).to render_template(:index)
    end

    it 'when logged in as admin user: render user index' do
      session[:user_id] = admin_user.id
      get :index
      expect(response).to render_template(:index)
    end

    it 'when logged in as non-admin user: redirect to home page' do
      session[:user_id] = user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: redirect to log in page' do
      get :index
      expect(response).to redirect_to log_in_path
    end
  end
end
