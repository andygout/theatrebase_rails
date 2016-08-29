require 'rails_helper'

describe UsersController, type: :controller do
  let!(:super_admin_user) { create :super_admin_user }
  let!(:admin_user) { create :admin_user }
  let!(:user) { create :user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:second_suspended_super_admin_user) { create :second_suspended_super_admin_user }
  let(:second_suspended_admin_user) { create :second_suspended_admin_user }
  let(:second_suspended_user) { create :second_suspended_user }
  let(:user_attrs) { attributes_for :user }

  let(:user_params) {
    {
      name:   user_attrs[:name],
      email:  user_attrs[:email]
    }
  }

  let(:whitespace_user_params) { add_whitespace_to_values(user_params) }

  context 'attempt create user' do
    it 'as super-admin user: succeed and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: user_params }.to change { User.count }.by 1
      expect(response).to redirect_to root_path
    end

    it 'as admin user: succeed and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { post :create, user: user_params }.to change { User.count }.by 1
      expect(response).to redirect_to root_path
    end

    it 'as non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      expect { post :create, user: user_params }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended super-admin user: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { post :create, user: user_params }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin user: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { post :create, user: user_params }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin user: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { post :create, user: user_params }.to change { User.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { post :create, user: user_params }.to change { User.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user with admin status (via web request)' do
    before(:each) do
      user_params[:admin_attributes] = { _destroy: '0' }
    end

    it 'as super-admin user: user created but admin status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: user_params }
        .to change { User.count }.by(1)
        .and change { Admin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not created nor super-admin status assigned; redirect to log in page' do
      expect { post :create, user: user_params }
        .to change { User.count }.by(0)
        .and change { Admin.count }.by(0)
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user with super-admin status (via web request)' do
    before(:each) do
      user_params[:super_admin_attributes] = { _destroy: '0' }
    end

    it 'as super-admin user: user created but super-admin status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: user_params }
        .to change { User.count }.by(1)
        .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not created nor super-admin status assigned; redirect to log in page' do
      expect { post :create, user: user_params }
        .to change { User.count }.by(0)
        .and change { SuperAdmin.count }.by(0)
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create user with suspended status (via web request)' do
    before(:each) do
      user_params[:suspension_attributes] = { _destroy: '0' }
    end

    it 'as super-admin user: user created but suspended status not assigned; response as expected' do
      session[:user_id] = super_admin_user.id
      expect { post :create, user: user_params }
        .to change { User.count }.by(1)
        .and change { Suspension.count }.by(0)
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: user not created nor suspended status assigned; redirect to log in page' do
      expect { post :create, user: user_params }
        .to change { User.count }.by(0)
        .and change { Suspension.count }.by(0)
      expect(response).to redirect_to log_in_path
    end
  end

  context 'permitted user creation' do
    it 'will remove leading and trailing whitespace from string fields' do
      session[:user_id] = admin_user.id
      post :create, user: whitespace_user_params
      user = User.last
      expect(user.name).to eq user_attrs[:name]
      expect(user.email).to eq user_attrs[:email]
    end

    it 'will set creator and updater associations' do
      session[:user_id] = admin_user.id
      post :create, user: user_params
      user = User.last
      expect(user.creator).to eq admin_user
      expect(user.updater).to eq admin_user
      expect(admin_user.created_users).to include user
      expect(admin_user.updated_users).to include user
    end
  end
end
