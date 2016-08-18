class AdminStatusController < ApplicationController

  include Shared::StatusHelper

  before_action :get_user
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :admin_status_assignor
  before_action -> { get_status_edit_components :admin }, only: [:edit]

  def edit
    @user.admin || @user.build_admin
  end

  def update
    @user.update(user_status_params(:admin))
    flash[:success] = 'Admin status updated successfully'
    redirect_to @user
  end

    private

    def get_user
      @user = User.find(params[:user_id])
    end

    def admin_status_assignor
      validate_user valid_admin_status_assignor? @user
    end

end
