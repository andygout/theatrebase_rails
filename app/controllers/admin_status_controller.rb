class AdminStatusController < ApplicationController

  include Shared::GetUserHelper
  include Shared::StatusHelper

  before_action -> { get_user(params[:user_id]) }
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :admin_status_assignor

  def edit
    get_status_edit_components(:admin)
    @user.admin || @user.build_admin
  end

  def update
    @user.update(user_status_params(:admin))
    flash[:success] = success_msg('Admin status', 'updated', get_user_page_title)
    redirect_to @user
  end

    private

    def admin_status_assignor
      validate_user valid_admin_status_assignor? @user
    end

end
