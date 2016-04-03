require 'rails_helper'

describe FormsHelper, type: :helper do
  let(:production) { create :production }
  let(:created_user) { create :created_user }
  let(:admin_user) { create :admin_user }
  let(:suspended_user) { create :suspended_user }

  context "outputting 'created + updated' info markup" do
    it 'info for new user' do
      markup = get_created_updated_info(User.new)
      expect(markup).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>First created:</td><td>"\
              "TBC"\
          "</td></tr>"\
          "<tr><td class='description-text'>Last updated:</td><td>"\
              "TBC"\
          "</td></tr>"\
        "</table></div>"
    end

    it 'info for existing user' do
      markup = get_created_updated_info(created_user)
      expect(markup).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>First created:</td><td>"\
              "#{created_user.created_at.strftime('%a, %d %b %Y at %H:%M')} "\
              "by #{created_user.creator.name} (#{created_user.creator.email})"\
          "</td></tr>"\
          "<tr><td class='description-text'>Last updated:</td><td>"\
              "#{created_user.updated_at.strftime('%a, %d %b %Y at %H:%M')} "\
              "by #{created_user.updater.name} (#{created_user.updater.email})"\
          "</td></tr>"\
        "</table></div>"
    end

    it 'info for existing user created by default (i.e. no created info) but with updated info' do
      created_user.creator = nil
      markup = get_created_updated_info(created_user)
      expect(markup).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>First created:</td><td>TBC</td></tr>"\
          "<tr><td class='description-text'>Last updated:</td><td>"\
              "#{created_user.updated_at.strftime('%a, %d %b %Y at %H:%M')} "\
              "by #{created_user.updater.name} (#{created_user.updater.email})"\
          "</td></tr>"\
        "</table></div>"
    end

    it 'info for new production' do
      markup = get_created_updated_info(Production.new)
      expect(markup).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>First created:</td><td>"\
              "TBC"\
          "</td></tr>"\
          "<tr><td class='description-text'>Last updated:</td><td>"\
              "TBC"\
          "</td></tr>"\
        "</table></div>"
    end

    it 'info for existing production' do
      markup = get_created_updated_info(production)
      expect(markup).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>First created:</td><td>"\
              "#{production.created_at.strftime('%a, %d %b %Y at %H:%M')} "\
              "by #{production.creator.name} (#{production.creator.email})"\
          "</td></tr>"\
          "<tr><td class='description-text'>Last updated:</td><td>"\
              "#{production.updated_at.strftime('%a, %d %b %Y at %H:%M')} "\
              "by #{production.updater.name} (#{production.updater.email})"\
          "</td></tr>"\
        "</table></div>"
    end
  end

  context "outputting 'status assigned' info markup" do
    it 'info for user without admin or suspension status' do
      markup = get_status_assigned_info(nil)
      expect(markup).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Assigned:</td><td>TBC</td></tr>"\
        "</table></div>"
    end

    it 'info for user with admin status' do
      markup = get_status_assigned_info(admin_user.admin)
      expect(markup).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Assigned:</td><td>"\
            "#{admin_user.admin.created_at.strftime('%a, %d %b %Y at %H:%M')} "\
            "by #{admin_user.admin.assignor.name} (#{admin_user.admin.assignor.email})"\
          "</td></tr>"\
        "</table></div>"
    end

    it 'info for user with suspension status' do
      markup = get_status_assigned_info(suspended_user.suspension)
      expect(markup).to eq \
        "<div class='content-container'><table class='table'>"\
          "<tr><td class='description-text'>Assigned:</td><td>"\
            "#{suspended_user.suspension.created_at.strftime('%a, %d %b %Y at %H:%M')} "\
            "by #{suspended_user.suspension.assignor.name} (#{suspended_user.suspension.assignor.email})"\
          "</td></tr>"\
        "</table></div>"
    end
  end
end
