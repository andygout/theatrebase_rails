class AdminStatusController < ApplicationController

  include FormHelper

  before_action :get_user
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :admin_status_assignor

  def edit
    @status_assigned_info = create_status_assigned_markup(@user.admin || false).html_safe
    @user.admin || @user.build_admin
    @page_title = "#{@user.name} (#{@user.email})"
    @content_header = "<p class='content-label content-header'>USER</p>".html_safe
  end

  def update
    @user.update(user_params)
    flash[:success] = 'Admin status updated successfully'
    redirect_to @user
  end

    private

    def user_params
      params
        .require(:user)
        .permit(admin_attributes: [:_destroy,
                                   :id])
        .deep_merge(admin_attributes: { assignor_id: current_user.id })
    end

    def get_user
      @user = User.find(params[:user_id])
    end

    def admin_status_assignor
      validate_user valid_admin_status_assignor? @user
    end

end
