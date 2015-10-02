require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create :user }
  let(:second_user) { create :second_user }

  context "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  context 'attempt edit when not logged in' do
    it 'should redirect to login page' do
      get :edit, id: user
      expect(response).to redirect_to(login_path)
    end
  end

  context 'attempt update when not logged in' do
    it 'should redirect to login page' do
      patch :update, id: user, user: { name: user[:name], email: user[:email] }
      expect(response).to redirect_to(login_path)
    end
  end

  context 'attempt edit when logged in as incorrect user' do
    it 'should redirect to home page' do
      session[:user_id] = second_user.id
      get :edit, id: user
      expect(response).to redirect_to(root_path)
    end
  end

  context 'attempt update when logged in as incorrect user' do
    it 'should redirect to home page' do
      session[:user_id] = second_user.id
      patch :update, id: user, user: { name: user[:name], email: user[:email] }
      expect(response).to redirect_to(root_path)
    end
  end

  context 'attempt to visit index when not logged in' do
    it 'should redirect to login page' do
      get :index
      expect(response).to redirect_to(login_path)
    end
  end
end
