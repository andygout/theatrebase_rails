require 'rails_helper'

describe UsersController, type: :controller do
  let!(:user) { create :user }
  let!(:second_user) { create :second_user }
  let!(:admin_user) { create :admin_user }
  let!(:second_admin_user) { create :second_admin_user }

  context "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  context 'attempt edit' do
    it 'when not logged in: redirect to login page' do
      get :edit, id: user
      expect(response).to redirect_to login_path
    end

    it 'when logged in as incorrect user: redirect to home page' do
      session[:user_id] = second_user.id
      get :edit, id: user
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt update' do
    it 'when not logged in: redirect to login page' do
      patch :update, id: user, user: { name: user[:name], email: user[:email] }
      expect(response).to redirect_to login_path
    end

    it 'when logged in as incorrect user: redirect to home page' do
      session[:user_id] = second_user.id
      patch :update, id: user, user: { name: user[:name], email: user[:email] }
      expect(response).to redirect_to root_path
    end
  end

  context 'attempt to visit index when not logged in' do
    it 'redirect to login page' do
      get :index
      expect(response).to redirect_to login_path
    end
  end

  context 'attempt delete when not logged in' do
    it 'redirect to home page' do
      expect { delete :destroy, id: user }.to change { User.count }.by 0
      expect(response).to redirect_to login_path
    end
  end

  context 'delete when logged in as non-admin' do
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
