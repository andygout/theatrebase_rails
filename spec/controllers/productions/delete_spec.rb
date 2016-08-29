require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let!(:production) { create :production }

  context 'attempt delete production' do
    it 'as super-admin: succeed and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as admin: succeed and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as non-admin: succeed and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end
end
