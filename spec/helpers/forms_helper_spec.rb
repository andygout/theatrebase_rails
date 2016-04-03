require 'rails_helper'

describe FormsHelper, type: :helper do
  let(:production) { create :production }
  let(:created_user) { create :created_user }
  let(:admin_user) { create :admin_user }
  let(:suspended_user) { create :suspended_user }

  context "outputting 'created + updated' info markup" do
    it 'info for new model instance' do
      vars = [User.new, Production.new]
      vars.each do |var|
        markup = get_created_updated_info(var)
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
    end

    it 'info for existing model instance' do
      vars = [created_user, production]
      vars.each do |var|
        markup = get_created_updated_info(var)
        expect(markup).to eq \
          "<div class='content-container'><table class='table'>"\
            "<tr><td class='description-text'>First created:</td><td>"\
                "#{var.created_at.strftime('%a, %d %b %Y at %H:%M')} "\
                "by #{var.creator.name} (#{var.creator.email})"\
            "</td></tr>"\
            "<tr><td class='description-text'>Last updated:</td><td>"\
                "#{var.updated_at.strftime('%a, %d %b %Y at %H:%M')} "\
                "by #{var.updater.name} (#{var.updater.email})"\
            "</td></tr>"\
          "</table></div>"
      end
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
