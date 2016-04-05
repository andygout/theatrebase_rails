require 'rails_helper'

describe Users::ViewsComponentsHelper, type: :helper do
  let(:user) { create :user }
  let(:suspended_user) { create :suspended_user }
  let(:admin_user) { create :admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }

  context 'outputting status info markup' do
    it 'unsuspended non-admin user' do
      @user = user
      expect(get_status_info).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Admin status:</td><td>Standard</td></tr><tr>"\
          "<td class='description-text'>Suspension status:</td><td>Not suspended</td></tr>"\
        "</table></div>"
    end

    it 'suspended non-admin user' do
      @user = suspended_user
      expect(get_status_info).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Admin status:</td><td>Standard</td></tr><tr>"\
          "<td class='description-text'>Suspension status:</td><td>Suspended</td></tr>"\
        "</table></div>"
    end

    it 'unsuspended admin user' do
      @user = admin_user
      expect(get_status_info).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Admin status:</td><td>Admin</td></tr><tr>"\
          "<td class='description-text'>Suspension status:</td><td>Not suspended</td></tr>"\
        "</table></div>"
    end

    it 'suspended admin user' do
      @user = suspended_admin_user
      expect(get_status_info).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Admin status:</td><td>Admin</td></tr><tr>"\
          "<td class='description-text'>Suspension status:</td><td>Suspended</td></tr>"\
        "</table></div>"
    end

    it 'unsuspended super-admin user' do
      @user = super_admin_user
      expect(get_status_info).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Admin status:</td><td>Super admin</td></tr><tr>"\
          "<td class='description-text'>Suspension status:</td><td>Not suspended</td></tr>"\
        "</table></div>"
    end

    it 'suspended super-admin user' do
      @user = suspended_super_admin_user
      expect(get_status_info).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Admin status:</td><td>Super admin</td></tr><tr>"\
          "<td class='description-text'>Suspension status:</td><td>Suspended</td></tr>"\
        "</table></div>"
    end
  end
end
