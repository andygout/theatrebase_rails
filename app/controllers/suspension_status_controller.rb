class SuspensionStatusController < ApplicationController

  include Shared::GetUserHelper
  include Shared::StatusHelper

  before_action -> { get_user(params[:user_id]) }
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :suspension_status_assignor

  def edit
    get_status_edit_components(:suspension)
    @user.suspension || @user.build_suspension
  end

  def update
    @user.update(user_status_params(:suspension))
    flash[:success] = success_msg('Suspension status', 'updated', get_user_page_title)
    redirect_to @user
  end

    private

    def suspension_status_assignor
      validate_user valid_suspension_status_assignor? @user
    end

end
